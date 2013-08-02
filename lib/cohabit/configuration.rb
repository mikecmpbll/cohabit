require "cohabit/version"
require "cohabit/configuration/settings"
require "cohabit/configuration/strategies"
require "cohabit/configuration/scopes"
require "active_record"

module Cohabit
  class Configuration

    attr_reader :load_paths

    def initialize(config_file = nil)
      @load_paths = [".", File.expand_path(File.join(File.dirname(__FILE__), "strategies"))]
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

    # simple require to pull in config files, eg 'basic'
    def require(files)
      [files].flatten.each do |file|
        load_paths.each do |path|
          if file.match(/\.rb\z/)
            name = File.join(path, file)
          else
            name = File.join(path, "#{file}.rb")
          end
          load(file: name) if File.file?(name)
        end
      end
    end

    include Settings, Strategies, Scopes

  end
end