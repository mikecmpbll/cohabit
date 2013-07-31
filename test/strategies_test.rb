require 'test_helper'
 
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
    # strategy block defaults > strategy arg defaults > global defaults

    # should inherit global defaults:
    @c.load do
      strategy :frankel
    end
    assert_equal(@c.settings[:scope_validations], @c.strategies.first.settings[:scope_validations])

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

  def test_strategy_inherits_and_overrides_modified_global_settings
    # should inherit monkey business
    @c.load do
      set :tenant_association, "monkey business"
      strategy :benjamin
    end
    assert_equal("monkey business", @c.strategies.first.settings[:tenant_association])

    # should override global setting monkey business with peanuts!
    setup
    @c.load do
      set :tenant_association, "monkey business"
      strategy :benjamin, tenant_association: :peanuts
    end
    assert_equal(:peanuts, @c.strategies.first.settings[:tenant_association])

    # and in block mode for good measure.
    setup
    @c.load do
      set :tenant_association, "monkey business"
      strategy :benjamin do
        set :tenant_association, :salted
      end
    end
    assert_equal(:salted, @c.strategies.first.settings[:tenant_association])
  end

end