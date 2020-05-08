# frozen_string_literal: true

module FinApps
  module REST
    class EsignTemplates < FinAppsCore::REST::Resources
      def list
        super('esign_templates')
      end
    end
  end
end
