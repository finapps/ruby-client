# frozen_string_literal: true

module FinApps
  module REST
    class AlertDefinitions < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder
      END_POINT = 'portfolio/alerts/definitions'

      def list(params=nil)
        return super END_POINT if params.nil?
        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(END_POINT, params)
      end

      def show

      end

      private

      def build_filter(_params)
        # no filter for now, functionality will be determined by feedback
        filter = {}
        filter
      end

    end
  end
end
