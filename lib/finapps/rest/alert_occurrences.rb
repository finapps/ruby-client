# frozen_string_literal: true

module FinApps
  module REST
    class AlertOccurrences < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder
      END_POINT = 'portfolio/alerts/occurrences'

      def list(params = nil)
        return super END_POINT if params.nil?
        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(END_POINT, params)
      end

      private

      def build_filter(params)
        filter = {}
        filter[:"portfolio.id"] = params[:portfolio_id] if params[:portfolio_id]
        filter
      end
    end
  end
end
