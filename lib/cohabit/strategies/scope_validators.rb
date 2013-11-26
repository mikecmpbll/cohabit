strategy :scope_validators do
  model_eval do |_scope|
    reflection = reflect_on_association _scope.settings[:association]
    foreign_key = reflection.foreign_key
    _validators.each do |attribute, validations|
      validations.reject!{|v| v.kind == :uniqueness}
    end
    new_callback_chain = self._validate_callbacks.reject do |callback|
      callback.raw_filter.is_a?(ActiveRecord::Validations::UniquenessValidator)
    end
    deleted = self._validate_callbacks - new_callback_chain
    (self._validate_callbacks.clear << new_callback_chain).flatten!
    deleted.each do |c|
      v = c.raw_filter
      v.attributes.each do |a|
        validates_uniqueness_of *v.attributes, v.options.merge(scope: foreign_key)
      end
    end
  end
end