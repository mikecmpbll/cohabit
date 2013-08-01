class StrategiesTest < Test::Unit::TestCase

  def setup
    @c = Cohabit::Configuration.new
  end

  def test_define_strategy
    @c.strategy(:frankel) do
      model_eval do
        puts "do this in the model! hurah."
      end
    end
    assert(@c.strategies.one?)
  end

  def test_define_strategy_with_config
    @c.load do
      strategy :frankel do
        model_eval do
          puts "do this in the model! hurah."
        end
      end
    end
    assert(@c.strategies.one?)
  end

  def test_cant_add_same_named_strategies
    assert_raise(Cohabit::StrategyNameExistsError) do
      @c.load do
        strategy :frankel
        strategy :frankel # eh-uhhh, no can do.
      end
    end
  end

  def test_strategy_inherits_correct_settings
    # strategy block defaults > strategy arg defaults

    # should take on strategy default settings when passed in
    setup
    @c.load do
      strategy :frankel, { scope_validations: true }
    end
    assert_equal(true, @c.strategies.first.settings[:scope_validations])

    # should take on strategy default settings when set in block
    # overriding any defaults passed as arguments
    setup
    @c.load do
      strategy :frankel, { scope_validations: "henry cecil" } do
        set :scope_validations, true
      end
    end
    assert_equal(true, @c.strategies.first.settings[:scope_validations])
  end

end