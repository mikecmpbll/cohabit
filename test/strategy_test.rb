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
    @c.load do
      require 'basic'
      scope :ybur, :basic, association: :client
    end
    @c.apply_scopes!

    # test before_validation to add scope association
    c = Client.create(name: "fubar")
    Cohabit.current_tenant = c
    y = Ybur.create(joke: "I took my tomcats to get neutered today. No hard felines")
    assert_same(c, y.client)

    # test default_scope
    c2 = Client.create(name: "rabuf")
    Cohabit.current_tenant = c2
    y2 = Ybur.create(joke: "I just ordered 10,000 bottles of TippEx. I made a massive mistake.")
    assert_equal(1, Ybur.count)
  end

end