# frozen_string_literal: true
module FinApps
  module REST
    class InstitutionsForms < FinApps::REST::Resources
      require 'erb'
      using ObjectExtensions
      using StringExtensions

      def show(site_id)
        raise MissingArgumentsError.new 'Missing argument: site_id.' if site_id.blank?

        path = "institutions/site/#{ERB::Util.url_encode(site_id)}/form"
        super site_id, path
      end
    end
  end
end
