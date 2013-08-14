class SettingsTest < Test::Unit::TestCase

  def setup
    @c = Cohabit::Configuration.new
  end
 
  def test_set_setting
    @c.set :scope_validations, true
    assert_equal(true, @c.settings[:scope_validations])
  end

  def test_set_setting_with_config
    assert_equal(:tenant, @c.settings[:association])
    @c.load do
      set :association, :client
    end
    assert_equal(:client, @c.settings[:association])
  end

end