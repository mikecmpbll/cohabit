require "cohabit/configuration/settings"

module Cohabit
  class Strategy

    def initialize(*args, &block)
      raise ArgumentError, "you must supply a name" if args.empty?
      @name = args.shift.to_sym
      @settings = args.last.is_a?(Hash) ? args.last : {}
      instance_eval(&block) unless block.nil?
    end

    include Configuration::Settings

    attr_reader :name, :model_code

    def model_eval(&block)
      @model_code = block
    end

  end
end