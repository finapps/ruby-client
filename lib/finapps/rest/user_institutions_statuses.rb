# frozen_string_literal: true
module FinApps
  module REST
    class UserInstitutionsStatuses < FinApps::REST::Resources # :nodoc:
      require 'erb'

      using ObjectExtensions
      using StringExtensions

      def show(ui_id)
        raise MissingArgumentsError.new 'Missing argument: ui_id' if ui_id.blank?

        path = "institutions/user/#{ERB::Util.url_encode(ui_id)}/status"
        super ui_id, path
      end

      # def update
      #   #User Institution Refresh All
      # end
    end
  end
end

