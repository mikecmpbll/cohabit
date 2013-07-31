# strategy :multi do
#   model_eval do
#     reflection = reflect_on_association _scope.settings[:tenant_association]
#     scope_validators(reflection.foreign_key) if _scope.settings[:scope_validations]
#     before_create Proc.new {|m|
#       return unless _scope.current_school
#       m.send "#{_scope.settings[:tenant_association]}=".to_sym, _scope.current_school
#     }
#     default_scope lambda {
#       where(reflection.foreign_key => _scope.current_scope) if _scope.current_scope
#     }
#   end
# end