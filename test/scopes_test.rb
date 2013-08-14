class ScopesTest < Test::Unit::TestCase

  def setup
    @c = Cohabit::Configuration.new
  end

  def teardown
    Ybur.default_scopes.clear
    Ybur._validators.clear
    [:validate, :validation, :save, :create, :update, :destroy].each do |type|
      Ybur.reset_callbacks(type)
    end
    Ybur.reflections.clear

    Client.delete_all
    Ybur.delete_all
  end

  def test_add_valid_scope
    # load basic strategy
    @c.load do
      require 'basic'
      scope :ybur, :basic, association: :client
    end
    assert(@c.scopes.any?)
  end

  def test_settings_for_scope
    @c.load do
      require 'basic'
      scope :ybur, :basic, association: :client
    end
    assert_equal(:client, @c.scopes.first.settings[:association])
  end

  def test_settings_for_scope_globally
    @c.load do
      require 'basic'
      set :association, :client
      scope :ybur, :basic
    end
    assert_equal(:client, @c.scopes.first.settings[:association])
  end

  def test_apply_scope_to_model
    client = Client.create(name: "fubar")
    Cohabit.current_tenant = client
    @c.load do
      require 'basic'
      scope :ybur, :basic
    end
    @c.apply_scopes!
    assert_not_equal(Ybur.unscoped.to_sql, Ybur.scoped.to_sql)
  end

  def test_setting_association_name
    client = Client.create(name: "fubar")
    Cohabit.current_tenant = client
    @c.load do
      require 'basic'
      scope :ybur, :basic, association: :client
    end
    @c.apply_scopes!
    assert_match(/client_id/, Ybur.scoped.to_sql)
  end

  def test_nested_strategy_scope_basic
    client = Client.create(name: "fubar")
    Cohabit.current_tenant = client
    # should run like normal basic strategy
    @c.load do
      require 'basic'
      strategy :frankel, { association: :client } do
        include_strategy :basic
      end
      scope :ybur, :frankel
    end
    @c.apply_scopes!
    assert_not_equal(Ybur.unscoped.to_sql, Ybur.scoped.to_sql)
  end

  def test_nested_strategy_scope_override
    client = Client.create(name: "fubar")
    Cohabit.current_tenant = client
    # should remove basic strategy's default scope, as it
    # is evaluated after it in the main strategy
    @c.load do
      require 'basic'
      strategy :frankel, { association: :client } do
        include_strategy :basic
        model_eval do |_scope|
          default_scopes.clear
        end
      end
      scope :ybur, :frankel
    end
    @c.apply_scopes!
    assert_equal(Ybur.unscoped.to_sql, Ybur.scoped.to_sql)
  end

  def test_evaluation_order_in_nested_strategies
    client = Client.create(name: "fubar")
    Cohabit.current_tenant = client
    # should remove basic strategy's default scope, as it
    # is evaluated after it in the main strategy
    @c.load do
      require 'basic'
      strategy :frankel, { association: :client } do
        model_eval do |_scope|
          default_scopes.clear
        end
        include_strategy :basic
      end
      scope :ybur, :frankel
    end
    @c.apply_scopes!
    assert_not_equal(Ybur.unscoped.to_sql, Ybur.scoped.to_sql)
  end

end