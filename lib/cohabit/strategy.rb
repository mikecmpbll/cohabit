require "cohabit/configuration/settings"

module Cohabit
  class Strategy

    def initialize(*args, &block)
      raise ArgumentError, "you must supply a name" if args.empty?
      @strategies = []
      @name = args.shift.to_sym
      @settings = args.last.is_a?(Hash) ? args.last : {}
      instance_eval(&block) unless block.nil?
    end

    include Configuration::Settings

    attr_reader :name, :model_code, :strategies

    def model_eval(&block)
      @model_code = block
      @strategies << @name
    end

    def include_strategy(name, options = {})
      name = name.to_sym
      raise ArgumentError if name.nil?
      if @strategies.include?(name)
        raise Argumenterror, "can't nest the same strategy twice
        or use two model_eval blocks in the same strategy"
      end
      @strategies << name
    end

  end
end