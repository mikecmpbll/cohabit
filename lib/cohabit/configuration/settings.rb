module Cohabit
  class Configuration
    module Settings

      DEFULT_SETTINGZ = {
        scope_validations: false,
        scope_url_helpers: false,
        association: :tenant
      }

      CUSTOM_HANDLERS = [:globals]

      def self.included(base)
        base.send :alias_method, :initialize_without_settings, :initialize
        base.send :alias_method, :initialize, :initialize_with_settings
      end

      # deez are our global settings for this configuration instance
      attr_reader :settings

      def initialize_with_settings(*args, &block)
        @settings = DEFULT_SETTINGZ.dup
        initialize_without_settings(*args, &block)
      end

      def merge_settings!(settings)
        settings.delete_if{ |s| !DEFULT_SETTINGZ.include?(s) }
        @settings.merge!(settings)
      end

      def generate_settings_hash!(args)
        if args.last.is_a?(Hash)
          args[args.length-1] = @settings.merge(args.last)
        else
          args << @settings.dup
        end
      end

      def set(setting, value)
        setting = setting.to_sym
        if CUSTOM_HANDLERS.include?(setting)
          send("set_#{setting}", value) and return
        end
        if !DEFULT_SETTINGZ.include?(setting)
          raise ArgumentError, "what the fuck are you doing.. that's not a setting"
        end
        @settings[setting] = value
      end

      def set_globals(value)
        [value].flatten.each do |v|
          Cohabit.add_global(v) unless Cohabit.respond_to?(v)
        end
      end

    end
  end
end