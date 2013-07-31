require 'test_helper'
 
class ScopesTest < Test::Unit::TestCase

  def setup
    @c = Cohabit::Configuration.new
  end

  def test_add_valid_scope
    # load basic strategy
    strategy_file = File.expand_path(File.join(File.dirname(__FILE__), "../lib/cohabit/strategies/basic.rb"))
    @c.load file: strategy_file
    @c.load do
      scope :ybur, :basic, tenant_association: :client
    end
    assert(@c.scopes.any?)
  end

end