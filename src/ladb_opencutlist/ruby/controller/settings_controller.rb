module Ladb::OpenCutList

  require_relative '../plugin'

  class SettingsController < Controller

    def initialize()
      super('settings')
    end

    def setup_commands()

      # Setup opencutlist dialog actions
      Plugin.instance.register_command("settings_dialog_settings") do |settings|
        dialog_settings_command(settings)
      end
      Plugin.instance.register_command("settings_dialog_inc_size") do |params|
        dialog_inc_size_command(params)
      end
      Plugin.instance.register_command("settings_dialog_inc_position") do |params|
        dialog_inc_position_command(params)
      end
      Plugin.instance.register_command('settings_set_length_settings') do |params|
        set_length_settings_command(params)
      end
      Plugin.instance.register_command('settings_get_length_settings') do |params|
        get_length_settings_command
      end
      Plugin.instance.register_command('settings_dump_global_presets') do |params|
        dump_global_presets_command
      end
      Plugin.instance.register_command('settings_dump_model_presets') do |params|
        dump_model_presets_command
      end
      Plugin.instance.register_command('settings_reset_global_presets') do |params|
        reset_global_presets_command
      end
      Plugin.instance.register_command('settings_reset_model_presets') do |params|
        reset_model_presets_command
      end

    end

    private

    # -- Commands --

    def dialog_settings_command(settings)

      # Check settings
      language = settings['language']
      print_margin = settings['print_margin']

      Plugin.instance.set_language(language, true)
      Plugin.instance.dialog_set_print_margin(print_margin, true)

    end

    def dialog_inc_size_command(params)
      inc_width = params['inc_width']
      inc_height = params['inc_height']

      Plugin.instance.dialog_inc_maximized_size(inc_width, inc_height)

    end

    def dialog_inc_position_command(params)
      inc_left = params['inc_left']
      inc_top = params['inc_top']

      Plugin.instance.dialog_inc_position(inc_left, inc_top)

    end

    def set_length_settings_command(params)
      length_unit = params['length_unit']
      length_format = params['length_format']
      length_precision = params['length_precision']
      suppress_units_display = params['suppress_units_display']

      unless length_format.nil?
        case length_format
        when DimensionUtils::FRACTIONAL, DimensionUtils::ARCHITECTURAL
          length_unit = DimensionUtils::INCHES
        when DimensionUtils::ENGINEERING
          length_unit = DimensionUtils::FEET
        end
      end

      model = Sketchup.active_model
      if model
        model.options['UnitsOptions']['LengthUnit'] = length_unit unless length_unit.nil?
        model.options['UnitsOptions']['LengthFormat'] = length_format unless length_format.nil?
        model.options['UnitsOptions']['LengthPrecision'] = length_precision unless length_precision.nil?
        model.options['UnitsOptions']['SuppressUnitsDisplay'] = suppress_units_display unless suppress_units_display.nil?
      end

      get_length_settings_command
    end

    def get_length_settings_command
      model = Sketchup.active_model

      return { :errors => [ 'default.error' ] } unless model

      length_format = model.options['UnitsOptions']['LengthFormat']
      {
          :length_unit => model.options['UnitsOptions']['LengthUnit'],
          :length_unit_disabled => length_format == DimensionUtils::FRACTIONAL || length_format == DimensionUtils::ARCHITECTURAL || length_format == DimensionUtils::ENGINEERING,
          :length_format => model.options['UnitsOptions']['LengthFormat'],
          :length_precision => model.options['UnitsOptions']['LengthPrecision'],
          :suppress_units_display => model.options['UnitsOptions']['SuppressUnitsDisplay'],
          :suppress_units_display_disabled => length_format == DimensionUtils::ARCHITECTURAL || length_format == DimensionUtils::ENGINEERING,
      }
    end

    def dump_global_presets_command
      SKETCHUP_CONSOLE.show
      Plugin.instance.dump_global_presets
    end

    def dump_model_presets_command
      SKETCHUP_CONSOLE.show
      Plugin.instance.dump_model_presets
    end

    def reset_global_presets_command
      Plugin.instance.reset_global_presets
    end

    def reset_model_presets_command
      Plugin.instance.reset_model_presets
    end

  end

end
