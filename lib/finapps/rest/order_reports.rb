# frozen_string_literal: true
module FinApps
  module REST
    class OrderReports < FinAppsCore::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def show(id, format)
        raise MissingArgumentsError.new 'Missing argument: id.' if id.blank?
        raise MissingArgumentsError.new 'Missing argument: format' if format.blank?
        raise InvalidArgumentsError.new 'Invalid argument: format' unless accepted_format?(format)

        path = "orders/#{ERB::Util.url_encode(id)}/report.#{ERB::Util.url_encode(format)}"
        super nil, path
      end

      private

      def accepted_format?(format)
        [:json, :html, :pdf].include? format.to_sym
      end
    end
  end
end
