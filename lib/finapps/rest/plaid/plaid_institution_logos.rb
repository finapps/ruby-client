# frozen_string_literal: true

module FinApps
  module REST
    class PlaidInstitutionLogos < PlaidResources # :nodoc:
      def show(id)
        super(nil, "p/institution/logo/#{id}")
      end
    end
  end
end