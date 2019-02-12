module FinApps
  module REST
    class Portfolios < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder

      def list(params = nil)
        return super if params.nil?
        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(end_point, params)
      end

      def show(id)
        not_blank(id, :id)
        super
      end

      def create(params)
        not_blank(params, :params)
        super params
      end

      def update(id, params)
        not_blank(id, :id)
        not_blank(params, :params)

        path = "#{end_point}/#{ERB::Util.url_encode(id)}"

        super params, path
      end

      def destroy(id)
        not_blank(id, :id)

        super
      end

      private

      def build_filter(params)
        # no filter for now, functionality will be determined by feedback
        filter={}
        filter
      end

      # need to populate build_filter method
    end
  end
end