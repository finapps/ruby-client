# frozen_string_literal: true
module FinApps
  module REST
    class Institutions < FinAppsCore::REST::Resources
      using ObjectExtensions
      using StringExtensions

      def list(search_term)
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: search_term' if search_term.blank?
        # API errors when search_term is blank, maybe it shouldn't

        path = "#{end_point}/search/#{ERB::Util.url_encode(search_term)}"
        super path
      end
    end
  end
end
