# frozen_string_literal: true
module FinApps
  module REST
    class Institutions < FinApps::REST::Resources
      require 'erb'
      using ObjectExtensions
      using StringExtensions

      def create(site_id, params)
        raise MissingArgumentsError.new 'Missing argument: site_id.' if site_id.blank?
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = "#{end_point}/site/#{ERB::Util.url_encode(site_id)}/add"

        super params, path
      end
    end
  end
end
