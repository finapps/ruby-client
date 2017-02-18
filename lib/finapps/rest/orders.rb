# frozen_string_literal: true
module FinApps
  module REST
    class Orders < FinAppsCore::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def show(id)
        not_blank(id, :id)
        super
      end

      def create(params)
        not_blank(params, :params)
        super params
      end

      # GET /v2/list/orders/:page/:requested/:sort/:asc
      # :page - page number requested
      # :requested - number of results per page requested
      # :sort - sort order
      #   options:
      #     date - the date of the order
      #     status - the status of the order
      # :asc - sort order true for asc false for desc
      def list# (params=nil) # params hash with optional keys [:page, :requested, :sort, :asc]
        super 'orders?page=1&requested=500&sort=-date'
        # TODO: change to support https://github.com/finapps/api/blob/develop/misc/docs/iav.md#get-list-of-orders
        #return super 'orders?page=1&requested=500&sort=-date' # if params.nil?
        #raise FinAppsCore::InvalidArgumentsError.new 'Invalid argument: params' unless params.is_a? Hash
        # super build_path(params)
      end

      def update(id, params)
        not_blank(id, :id)
        not_blank(params, :params)
        # Params array need matching Institution ids & Account ids
        # Validations to check each Institution id has at least one account id
        # Validations to check at least 1 Institution id or 1 account "params.length >= 1"

        path = "#{end_point}/#{ERB::Util.url_encode(id)}"

        super params, path
      end

      # private
      #
      # def build_path(p)
      #   # TODO: change to support https://github.com/finapps/api/blob/develop/misc/docs/iav.md#get-list-of-orders
      #
      #   page = p[:page] || 1
      #   requested = p[:requested] || 100
      #   sort = p[:sort] || 'date'
      #   asc = p[:asc]
      #   end_point = 'orders'
      #   path = end_point.dup
      #   [page, requested, sort, asc].each_with_index {|a| path << "/#{ERB::Util.url_encode(a)}" }
      #   path
      # end
    end
  end
end
