# frozen_string_literal: true
module FinApps
  module REST
    class Orders < FinApps::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def show(id)
        raise MissingArgumentsError.new 'Missing argument: id.' if id.blank?
        super
      end

      def list(_params=nil)
        # TODO: get the paramaters for the pagination
        # GET /v2/list/orders/:page/:requested/:sort/:asc
        # :page - page number requested
        # :requested - number of results per page requested
        # :sort - sort order
        # options:
        #     date - the date of the order
        #     status - the status of the order
        # :asc - sort order true for asc false for desc

        super 'list/orders/1/10000/date/false'
      end
    end
  end
end
