module Cohabit
  class RouteHelperScope

    def initialize(*args)
      merge_settings!(args.last) if args.last.is_a?(Hash)
    end

    include Configuration::Settings

    def apply!(context)
      named_routes = get_route_helpers

      route_helpers = Module.new
      route_helpers.module_exec(named_routes, @settings[:association], &route_override_proc)
      Cohabit.const_set("RouteHelpers", route_helpers)
      ActionView::Base.send :include, Cohabit::RouteHelpers
    end

    private
      def get_route_helpers
        named_routes_arr = Rails.application.routes.named_routes
          .find_all{|rn, _| rn =~ /#{Regexp.escape(@settings[:association_as])}_/}
          .group_by do |_, r|
            name = r.path.names[r.path.names.index("#{@settings[:association_as]}_id")+1]
            if name =~ /_id/
              name.gsub("_id", "")
            else
              r.defaults[:controller].classify.downcase
            end
          end
          .reject{|k, _| k.nil?}
          .map{|g, rs| [g, Hash[rs.map{|rn, r| [rn.to_s.gsub("#{@settings[:association_as]}_", "").to_sym, rn]}]]}
        # e.g. { student: { :school_student => :student, :school_edit_student => :edit_student } }
        return Hash[named_routes_arr]
      end

      def route_override_proc
        Proc.new do |named_routes, assoc|
          named_routes.each do |mr, rs|
            rs.each do |r, orig_r|
              module_eval <<-EOT, __FILE__, __LINE__ + 1
                def #{r}_path(*args)
                  do_dat_thang!("path", "#{assoc}", "#{mr}", "#{orig_r}", *args) || super
                end
                def #{r}_url(*args)
                  do_dat_thang!("url", "#{assoc}", "#{mr}", "#{orig_r}", *args) || super
                end
              EOT
            end
          end

          def do_dat_thang!(type, assoc, main_resource, orig_route, obj, *args)
            if obj.is_a?(Integer)
              model = main_resource.classify.constantize
              obj = model.find(obj)
            end
            if Cohabit.current_tenant.is_cluster? && obj.respond_to?(assoc)
              send("#{orig_route}_#{type}", obj.send(assoc), obj, *args)
            end
          end
        end
      end

  end
end