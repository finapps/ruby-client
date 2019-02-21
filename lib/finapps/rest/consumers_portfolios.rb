module FinApps
  module REST
    class ConsumersPortfolios < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder

      def list(id, params = nil)
        not_blank(id)

        return super if params.nil?
        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(end_point, params)
      end

    end
  end
end
