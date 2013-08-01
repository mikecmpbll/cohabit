strategy :basic do
  model_eval do |_scope|
    belongs_to _scope.settings[:tenant_association]
    reflection = reflect_on_association _scope.settings[:tenant_association]
    scope_validators(reflection.foreign_key) if _scope.settings[:scope_validations]
    before_create Proc.new {|m|
      return unless Cohabit.current_tenant
      m.send "#{_scope.settings[:tenant_association]}=".to_sym, Cohabit.current_tenant
    }
    default_scope lambda {
      where(reflection.foreign_key => Cohabit.current_tenant) if Cohabit.current_tenant
    }
  end
end