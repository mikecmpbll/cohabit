require 'test_helper'
 
class SettingsTest < Test::Unit::TestCase
 
  def test_set_real_setting
    b = Cohabit::Configuration.new
    assert_not_equal(b.settings[:scope_validations], true)
    b.set :scope_validations, true
    assert_equal(true, b.settings[:scope_validations])
  end

  def test_set_nonexitant_setting
    b = Cohabit::Configuration.new
    assert_raise(ArgumentError) do
      b.set :wtf_not_a_real_setting, "dis is a value, innit"
    end
  end

  def test_set_setting_with_config
    b = Cohabit::Configuration.new
    assert_equal(false, b.settings[:scope_validations])
    b.load do
      set :scope_validations, true
    end
    assert_equal(true, b.settings[:scope_validations])
  end

  def test_set_local_strategy_setting
  end

end