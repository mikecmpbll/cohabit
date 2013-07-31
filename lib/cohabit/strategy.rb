require "cohabit/configuration/settings"

module Cohabit
  class Strategy

    def initialize(*args, &block)
      raise ArgumentError, "you must supply a name" if args.one?
      @name = args.shift.to_sym
      merge_settings!(args.last) if args.last.is_a?(Hash)
      instance_eval(&block) unless block.nil?
    end

    include Configuration::Settings

    attr_reader :name

    def model_eval(&block)
      @model_eval = block 
    end

  end
end