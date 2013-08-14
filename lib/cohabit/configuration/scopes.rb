module Cohabit
  class Configuration
    module Scopes

      def self.included(base)
        base.send :alias_method, :initialize_without_scopes, :initialize
        base.send :alias_method, :initialize, :initialize_with_scopes
      end

      def initialize_with_scopes(*args)
        initialize_without_scopes(*args)
        @scopes = []
      end

      # deez are our scopes for our configuration instance
      attr_reader :scopes

      def scope(*args, &block)
        generate_settings_hash!(args)
        scope = Scope.new(*args, &block)
        add_scope(scope)
      end

      def apply_scopes!(context = self)
        @scopes.each{ |s| s.apply!(context) }
      end

      private
        def add_scope(scope)
          scopes << scope
        end

    end
  end
end