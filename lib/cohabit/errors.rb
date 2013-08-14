module Cohabit

  Error = Class.new(RuntimeError)
  
  StrategyNameExistsError = Class.new(Cohabit::Error)
  StrategyNotFoundError   = Class.new(Cohabit::Error)
  StrategyNestingError    = Class.new(Cohabit::Error)
  InvalidScopeError       = Class.new(Cohabit::Error)

end