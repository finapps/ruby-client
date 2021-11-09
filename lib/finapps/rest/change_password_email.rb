# frozen_string_literal: true

module FinApps
  module REST
    class ChangePasswordEmail < FinAppsCore::REST::Resources
      def create(params)
        not_blank(params, :params)
        super params, 'login/change_password_email'
      end
    end
  end
end
