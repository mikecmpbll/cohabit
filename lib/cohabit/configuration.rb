require "cohabit/version"
require "cohabit/configuration/settings"
require "cohabit/configuration/strategies"
require "cohabit/configuration/scopes"

module Cohabit
  class Configuration
    def initialize(config_file = nil)
      # @load_paths = [".", File.expand_path(File.join(File.dirname(__FILE__), "../recipes"))]
    end

    def load(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}

      if block
        raise ArgumentError, "loading a block requires 0 arguments" unless options.empty? && args.empty?
        instance_eval(&block)
      elsif options[:file]
        load string: File.read(options[:file])
      elsif options[:string]
        instance_eval(options[:string])
      end
    end

    include Settings, Strategies, Scopes
  end
end
