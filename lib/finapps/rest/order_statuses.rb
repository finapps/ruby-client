# frozen_string_literal: true
module FinApps
  module REST
    class OrderStatuses < FinApps::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def show(id)
        raise MissingArgumentsError.new 'Missing argument: id.' if id.blank?

        path = "orders/#{ERB::Util.url_encode(id)}/status"
        super nil, path
      end
    end
  end
end
