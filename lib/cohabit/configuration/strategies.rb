module Cohabit
  class Configuration
    module Strategies

      def self.included(base)
        base.send :alias_method, :initialize_without_strategies, :initialize
        base.send :alias_method, :initialize, :initialize_with_strategies
      end

      def initialize_with_strategies(*args)
        initialize_without_strategies(*args)
        @strategies = []
      end

      # deez are our strategies for our configuration instance
      attr_reader :strategies

      # defines a strategy. woah there batman!
      def strategy(*args, &block)
        strategy = Strategy.new(*args, &block)
        add_strategy(strategy)
      end

      def find_strategy_by_name(name)
        strategy = @strategies.find{|s| s.name == name}
        return strategy if strategy
        raise StrategyNotFoundError
      end

      private
        def add_strategy(strategy)
          raise StrategyNameExistsError if named_strategy_exists?(strategy.name)
          strategies << strategy
        end

        def named_strategy_exists?(strategy_name)
          strategies.any?{|s| s.name == strategy_name}
        end

    end
  end
end