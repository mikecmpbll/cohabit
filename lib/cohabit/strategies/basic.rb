strategy :basic do
  model_eval do |_scope|
    # _scope var references the scope that uses the strategy,
    # so to access settings, like :association, use
    # _scope.settings[:association]. current_tenant is defined
    # as Cohabit.current_tenant.
    belongs_to _scope.settings[:association]
    reflection = reflect_on_association _scope.settings[:association]
    before_create Proc.new {|m|
      return unless Cohabit.current_tenant
      m.send "#{_scope.settings[:association]}=".to_sym, Cohabit.current_tenant
    }
    default_scope lambda {
      where(reflection.foreign_key => Cohabit.current_tenant) if Cohabit.current_tenant
    }
  end
end