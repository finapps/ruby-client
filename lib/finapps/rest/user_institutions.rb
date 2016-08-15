# frozen_string_literal: true
module FinApps
  module REST
    class UserInstitutions < FinApps::REST::Resources # :nodoc:
      require 'erb'

      using ObjectExtensions
      using StringExtensions

      def list
        path = 'institutions/user'
        super path
      end

      def show(id)
        raise MissingArgumentsError.new 'Missing Argument: id.' if id.blank?

        path = "institutions/user/#{ERB::Util.url_encode(id)}"
        super id, path
      end
    end
  end
end
