require 'cohabit/errors'
require 'cohabit/configuration'
require 'cohabit/strategy'
require 'cohabit/scope'

module Cohabit
  class << self
    attr_accessor :current_tenant
  end

  module ActiveRecordExtensions
    def _apply_cohabit_scope(_scope)
      proc = _scope.strategy.model_code
      instance_exec(_scope, &proc) if proc
    end
  end
end

ActiveRecord::Base.extend Cohabit::ActiveRecordExtensions