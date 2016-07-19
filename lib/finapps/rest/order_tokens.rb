# frozen_string_literal: true
module FinApps
  module REST
    class OrderTokens < FinApps::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def show(token)
        raise MissingArgumentsError.new 'Missing argument: token.' if token.blank?

        create nil, "orders/#{ERB::Util.url_encode(token)}"
      end
    end
  end
end
