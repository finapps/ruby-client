# frozen_string_literal: true
module FinApps
  module REST
    class Orders < FinApps::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def show(id)
        raise MissingArgumentsError.new 'Missing argument: params.' if id.blank?
        super
      end

      def list(params=nil)
        # Params:
        # GET /v2/list/orders/:page/:requested/:sort/:asc
        # :page - page number requested
        # :requested - number of results per page requested
        # :sort - sort order
        # options:
        #     date - the date of the order
        #     status - the status of the order
        # :asc - sort order true for asc false for desc

        path = 'list/orders/1/10000/date/false' if params.ni?
        super path
      end
    end
  end
end
