strategy :multi do
  set :globals, :current_scope
  model_eval do |_scope|
    belongs_to _scope.settings[:association]
    reflection = reflect_on_association _scope.settings[:association]
    # insertions are scoped to current_tenant
    before_create Proc.new {|m|
      return unless Cohabit.current_tenant
      m.send "#{association}=".to_sym, Cohabit.current_tenant
    }
    # selects are scoped to multiple clients (stored in current_scope)
    default_scope lambda {
      where(reflection.foreign_key => Cohabit.current_scope) if Cohabit.current_scope
    }
  end
end