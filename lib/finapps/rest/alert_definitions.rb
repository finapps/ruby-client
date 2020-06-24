# frozen_string_literal: true

module FinApps
  module REST
    class AlertDefinitions < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder
      END_POINT = 'portfolio/alerts/definitions'

      def list(params = nil)
        return super END_POINT if params.nil?
        fail FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(END_POINT, params)
      end

      def show(id)
        not_blank(id, :id)
        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}"

        super nil, path
      end
    end
  end
end
