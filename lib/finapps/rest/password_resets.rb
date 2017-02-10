# frozen_string_literal: true
module FinApps
  module REST
    class PasswordResets < FinAppsCore::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def create(id)
        not_blank(id, :id)

        path = "tenant/#{ERB::Util.url_encode(id)}/password"
        super nil, path
      end

      def update(id, params)
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: id.' if id.blank?
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = "tenant/#{ERB::Util.url_encode(id)}/password"
        super params, path
      end
    end
  end
end
