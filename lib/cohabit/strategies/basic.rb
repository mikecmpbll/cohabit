strategy :basic do
  model_eval do
    belongs_to _scope.settings[:tenant_association]
    reflection = reflect_on_association _scope.settings[:tenant_association]
    scope_validators(reflection.foreign_key) if _scope.settings[:scope_validations]
    before_create Proc.new {|m|
      return unless _scope.current_tenant
      m.send "#{_scope.settings[:tenant_association]}=".to_sym, _scope.current_tenant
    }
    default_scope lambda {
      where(reflection.foreign_key => _scope.current_tenant) if _scope.current_tenant
    }
  end
end