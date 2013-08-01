require "cohabit/configuration/settings"
require "active_record"
require "active_support/inflector"

module Cohabit
  class Scope

    def initialize(*args, &block)
      merge_settings!(args.pop) if args.last.is_a?(Hash)
      apply_to(args[0])
      use_strategy(args[1])
      instance_eval(&block) unless block.nil?
      merge_settings!(@strategy.settings)
      unless valid?
        raise InvalidScopeError, "provide valid model(s) and strategy"
      end
    end

    include Configuration::Settings

    attr_reader :strategy

    def use_strategy(strategy)
      unless strategy.nil?
        @strategy = strategy
      end
    end

    def apply_to(models)
      @models = parse_models(models)
    end

    def apply!
      # SMASH IT INTO THE AR MODEL
      # oh yeah, this is the magic, baby.
      # mind-bending magic. (aka messy as shit)
      @models.each do |model|
        model.instance_eval do
          def _cohabit_scope(_scope)
            proc = _scope.strategy.model_code
            instance_exec(_scope, &proc) if proc
          end
        end
        # call it with this scope instance so it
        # can access settings and shiz.
        model._cohabit_scope(self)
      end
    end

    private
      def valid?
        return false if @models.empty?
        return false if @strategy.nil?
        @models.each do |model|
          return false if !ActiveRecord::Base.descendants.include?(model)
        end
        return true
      end

      def parse_models(models)
        [models].flatten.compact.map do |model|
          model.to_s.classify.constantize
        end
      end

  end
end