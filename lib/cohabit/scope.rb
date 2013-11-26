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
      unless valid?
        raise InvalidScopeError, "provide valid model(s) and strategy"
      end
    end

    include Configuration::Settings

    attr_reader :strategy

    def use_strategy(strategy)
      unless strategy.nil?
        @strategy_name = strategy
      end
    end

    def apply_to(models)
      @models = parse_models(models)
    end

    def apply!(context)
      # apply yourself! that's what my teachers always said.
      strategy_stack = get_strategies(@strategy_name, context)
      main_strategy = context.find_strategy_by_name(@strategy_name)
      merge_settings!(main_strategy.settings)
      @models.each do |model|
        strategy_stack.each do |strategy|
          model.instance_exec(self, &strategy.model_code)
        end
      end
    end

    private
      def valid?
        return false if @models.empty?
        return false if @strategy_name.nil?
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

      def get_strategies(strategy_name, context, strategy_stack = [])
        strategy = context.find_strategy_by_name(strategy_name)
        strategy.strategies.each do |s|
          if s == strategy.name
            if strategy_stack.include?(strategy)
              raise StrategyNestingError, "strategies can't be nested twice in the same stack"
            end
            strategy_stack << strategy
          else
            strategy_stack = get_strategies(s, context, strategy_stack)
          end
        end
        strategy_stack
      end

  end
end