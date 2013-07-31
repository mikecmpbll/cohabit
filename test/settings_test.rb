require 'test_helper'
 
class SettingsTest < Test::Unit::TestCase

  def setup
    @c = Cohabit::Configuration.new
  end
 
  def test_set_real_setting
    assert_not_equal(@c.settings[:scope_validations], true)
    @c.set :scope_validations, true
    assert_equal(true, @c.settings[:scope_validations])
  end

  def test_set_nonexitant_setting
    assert_raise(ArgumentError) do
      @c.set :wtf_not_a_real_setting, "dis is a value, innit"
    end
  end

  def test_set_setting_with_config
    assert_equal(false, @c.settings[:scope_validations])
    @c.load do
      set :scope_validations, true
    end
    assert_equal(true, @c.settings[:scope_validations])
  end

end