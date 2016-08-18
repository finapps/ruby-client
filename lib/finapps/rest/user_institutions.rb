# frozen_string_literal: true
module FinApps
  module REST
    class UserInstitutions < FinApps::REST::Resources # :nodoc:

      END_POINT = 'institutions/user'

      using ObjectExtensions
      using StringExtensions

      def list
        path = 'institutions/user'
        super path
      end

      def show(id)
        raise MissingArgumentsError.new 'Missing Argument: id.' if id.blank?

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}"
        super id, path
      end

      def credentials_update(id, params)
        raise MissingArgumentsError.new 'Missing Argument: id.' if id.blank?
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}/credentials"
        update params, path
      end

      def mfa_update(id, params)
        raise MissingArgumentsError.new 'Missing Argument: id.' if id.blank?
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}/mfa"
        update params, path
      end

      def destroy(id)
        raise MissingArgumentsError.new 'Missing Argument: id.' if id.blank?

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}"
        super id, path
      end

      private

      def update(params, path)
        super params, path
      end
    end
  end
end
