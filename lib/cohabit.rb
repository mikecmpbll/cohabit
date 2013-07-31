require 'cohabit/errors'
require 'cohabit/configuration'
require 'cohabit/strategy'
require 'cohabit/scope'

module Cohabit
  class << self
    attr_accessor :current_tenant
  end
end