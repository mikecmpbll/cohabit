 class ScopesTest < Test::Unit::TestCase

  def setup
    @c = Cohabit::Configuration.new
  end

  def teardown
    Client.unscoped.delete_all
    Ybur.unscoped.delete_all
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

  def test_settings_for_scope
    strategy_file = File.expand_path(File.join(File.dirname(__FILE__), "../lib/cohabit/strategies/basic.rb"))
    @c.load file: strategy_file
    @c.load do
      scope :ybur, :basic, tenant_association: :client
    end
    assert_equal(:client, @c.scopes.first.settings[:tenant_association])
  end 

  def test_apply_scope_to_model
    c = Client.create(name: "fubar")
    Cohabit.current_tenant = c
    strategy_file = File.expand_path(File.join(File.dirname(__FILE__), "../lib/cohabit/strategies/basic.rb"))
    @c.load file: strategy_file
    @c.load do
      scope :ybur, :basic
    end
    @c.apply_scopes!
    assert_not_equal(Ybur.unscoped.to_sql, Ybur.scoped.to_sql)
  end

  def test_setting_association_name
    c = Client.create(name: "fubar")
    Cohabit.current_tenant = c
    strategy_file = File.expand_path(File.join(File.dirname(__FILE__), "../lib/cohabit/strategies/basic.rb"))
    @c.load file: strategy_file
    @c.load do
      scope :ybur, :basic, tenant_association: :client
    end
    @c.apply_scopes!
    assert_match(/client_id/, Ybur.scoped.to_sql)
  end

end