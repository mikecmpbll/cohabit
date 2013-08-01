 class StrategyTest < Test::Unit::TestCase

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

  def test_basic_strategy
    c = Client.create(name: "fubar")
    Cohabit.current_tenant = c
    @c.load do
      require 'basic'
      scope :ybur, :basic, tenant_association: :client
    end
    @c.apply_scopes!
    # raise Ybur._validators.inspect
    y = Ybur.create(joke: "I took my tomcats to get neutered today. No hard felines")
    assert_same(c, y.client)
  end

end