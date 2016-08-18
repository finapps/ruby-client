# frozen_string_literal: true
module FinApps
  module REST
    class Institutions < FinApps::REST::Resources
      using ObjectExtensions
      using StringExtensions

      def create(site_id, params)
        raise MissingArgumentsError.new 'Missing argument: site_id.' if site_id.blank?
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = "#{end_point}/site/#{ERB::Util.url_encode(site_id)}/add"

        super params, path
      end

      def list(search_term)
        raise MissingArgumentsError.new 'Missing argument: search_term' if search_term.blank?
        # API errors when search_term is blank, maybe it shouldn't

        path = "#{end_point}/search/#{ERB::Util.url_encode(search_term)}"
        super path
      end
    end
  end
end
