# frozen_string_literal: true

module FinApps
  module REST
    class Institutions < FinAppsCore::REST::Resources
      ROUTING_NUMBER_LENGTH = 9

      def list(search_term)
        not_blank(search_term, :search_term) # API errors when search_term is blank, maybe it shouldn't

        path = "#{end_point}/search/#{ERB::Util.url_encode(search_term)}"
        super path
      end

      def show(id)
        digits = remove_non_digits id
        not_blank(digits, :id)

        path = "#{end_point}/#{search_type digits}/#{digits}"
        super digits, path
      end

      private

      def search_type(digits)
        digits.length >= ROUTING_NUMBER_LENGTH ? :routing : :site
      end

      def remove_non_digits(value)
        value.to_s.gsub(/\D/, '')
      end
    end
  end
end
