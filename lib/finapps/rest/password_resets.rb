# frozen_string_literal: true
module FinApps
  module REST
    class PasswordResets < FinApps::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def create(id)
        raise MissingArgumentsError.new 'Missing argument: id.' if id.blank?

        path = "tenant/#{ERB::Util.url_encode(id)}/password"
        super nil, path
      end

      def update(id, params)
        raise MissingArgumentsError.new 'Missing argument: id.' if id.blank?
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = "tenant/#{ERB::Util.url_encode(id)}/password"
        super params, path
      end
    end
  end
end
