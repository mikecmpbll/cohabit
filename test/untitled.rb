class Baz
  def initialize(*args, &block)
    @name = args.shift
    p block.inspect
  end
end

module Bar
  def use2(*args, &block)
    b = Baz.new(*args, &block)
  end
end

class Foo
  def use(&block)
    instance_eval(&block)
  end

  include Bar
end