# frozen_string_literal: true
module FinApps
  module REST
    class Institutions < FinAppsCore::REST::Resources
      def list(search_term)
        not_blank(search_term, :search_term)
        # API errors when search_term is blank, maybe it shouldn't

        path = "#{end_point}/search/#{ERB::Util.url_encode(search_term)}"
        super path
      end

      def show(routing_number)
        not_blank(routing_number, :routing_number)

        path = "#{end_point}/routing/#{remove_non_digits routing_number}"
        super routing_number, path
      end

      private

      def remove_non_digits(value)
        value.to_s.gsub(/\D/, '')
      end
    end
  end
end
