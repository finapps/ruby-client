# frozen_string_literal: true
module FinApps
  module REST
    class Orders < FinAppsCore::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def show(id)
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: id.' if id.blank?
        super
      end

      def create(params)
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: params.' if params.blank?
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
      def list(params=nil) # params hash with optional keys [:page, :requested, :sort, :asc]
        return super 'list/orders/1/10000/date/false' if params.nil?
        raise FinAppsCore::InvalidArgumentsError.new 'Invalid argument: params' unless params.is_a? Hash

        super build_path(params)
      end

      def update(id, params)
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: id.' if id.blank?
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: params' if params.blank?
        # Params array need matching Institution ids & Account ids
        # Validations to check each Institution id has at least one account id
        # Validations to check at least 1 Institution id or 1 account "params.length >= 1"

        path = "#{end_point}/#{ERB::Util.url_encode(id)}"

        super params, path
      end

      private

      def build_path(p)
        page = p[:page] || 1
        requested = p[:requested] || 100
        sort = p[:sort] || 'date'
        asc = p[:asc] || false
        end_point = 'list/orders'
        path = end_point.dup
        [page, requested, sort, asc].each_with_index {|a| path << "/#{ERB::Util.url_encode(a)}" }
        path
      end
    end
  end
end
