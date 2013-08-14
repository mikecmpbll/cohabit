require 'cohabit/errors'
require 'cohabit/configuration'
require 'cohabit/strategy'
require 'cohabit/scope'
require 'cohabit/route_helper_scope'

module Cohabit
  @data = {}
  class << self
    attr_accessor :current_tenant

    def add_global(name)
      singleton_class.send(:define_method, name) { @data[name] }
      singleton_class.send(:define_method, "#{name}=") { |val| @data[name] = val }
    end
  end
end

if defined?(Rails) && Rails::VERSION::MAJOR.to_i >= 3
  module Cohabit
    class Railtie < Rails::Railtie
      initializer "cohabit.initialize_scopes" do
        ActiveSupport.on_load :after_initialize do
          config = Cohabit::Configuration.new
          config.load(file: File.join(Rails.root, "config/cohabit.rb"))
          config.apply_all!
        end
      end
    end
  end
end