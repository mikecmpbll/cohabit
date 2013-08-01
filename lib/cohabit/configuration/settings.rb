module Cohabit
  class Configuration
    module Settings

      DEFULT_SETTINGZ = {
        scope_validations: false,
        scope_url_helpers: false,
        association: :tenant
      }

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
        if !DEFULT_SETTINGZ.include?(setting.to_sym)
          raise ArgumentError, "what the fuck are you doing.. that's not a setting"
        end
        @settings[setting.to_sym] = value
      end

    end
  end
end