require "cohabit/version"
require "cohabit/configuration/settings"
require "cohabit/configuration/strategies"
require "cohabit/configuration/scopes"
require "cohabit/configuration/route_helper_scopes"
require "active_record"
require "active_support/inflector"

module Cohabit
  class Configuration

    attr_reader :load_paths

    def initialize(config_file = nil)
      @load_paths = [Rails.root.join("lib"), Rails.root.join("config"), ".", File.expand_path(File.join(File.dirname(__FILE__), "strategies"))]
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

    def apply_all!
      self.class.ancestors.take_while{|a| a != self.class.superclass}
      .reject{|a| a == self.class}
      .each do |a|
        method = "apply_#{a.name.demodulize.underscore}!"
        self.send(method, self) if self.respond_to?(method)
      end
    end

    include Settings, Strategies, Scopes, RouteHelperScopes

  end
end