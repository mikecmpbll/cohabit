require 'cohabit/errors'
require 'cohabit/configuration'
require 'cohabit/strategy'
require 'cohabit/scope'

module Cohabit
  @data = {}
  class << self
    attr_accessor :current_tenant

    def add_global(name)
      singleton_class.send(:define_method, name) { @data[name] }
      singleton_class.send(:define_method, "#{name}=") { |val| @data[name] = val }
    end
  end

  module ActiveRecordExtensions
    def _apply_cohabit_scope(_scope)
      proc = _scope.strategy.model_code
      instance_exec(_scope, &proc) if proc
    end
  end
end

ActiveRecord::Base.extend Cohabit::ActiveRecordExtensions

if defined? Rails
  if Rails::VERSION::MAJOR.to_i >= 3
    module Cohabit
      class Railtie < Rails::Railtie
        initializer "cohabit.configure" do |app|
          config = Cohabit::Configuration.new
          config.load(file: File.join(Rails.root, "config/cohabit.rb"))
          config.apply_scopes!
        end
      end
    end
  else
    config = Cohabit::Configuration.new
    config.load(file: File.join(Rails.root, "config/cohabit.rb"))
    config.apply_scopes!
  end
end