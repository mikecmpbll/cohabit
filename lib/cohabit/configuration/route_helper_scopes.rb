module Cohabit
  class Configuration
    module RouteHelperScopes

      attr_accessor :route_scopes

      def scope_route_helpers(*args)
        generate_settings_hash!(args)
        (@route_scopes ||= []) << RouteHelperScope.new(*args)
      end

      def apply_route_helper_scopes!(context = self)
        @route_scopes.each{|rs| rs.apply!(context)}
      end

    end
  end
end