module Ladb::OpenCutList

  require_relative '../../tool/smart_paint_tool'

  class MaterialsSmartPaintWorker

    def initialize(settings)
      @name = settings['name']
    end

    # -----

    def run

      model = Sketchup.active_model
      return { :errors => [ 'tab.materials.error.no_model' ] } unless model

      # Fetch material
      materials = model.materials
      material = materials[@name]

      return { :errors => [ 'tab.materials.error.material_not_found' ] } unless material

      # Select Smart Paint Tool
      Sketchup.active_model.select_tool(SmartPaintTool.new(material))

      # Send action
      success = Sketchup.send_action('selectPaintTool:')

      {
          :success => success,
      }
    end

    # -----

  end

end