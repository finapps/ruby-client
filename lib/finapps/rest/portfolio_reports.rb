# frozen_string_literal: true

module FinApps
  module REST
    class PortfolioReports < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder

      def list(params = nil)
        path = 'portfolio/reports'

        return super path if params.nil?
        fail FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(path, params)
      end
    end
  end
end
