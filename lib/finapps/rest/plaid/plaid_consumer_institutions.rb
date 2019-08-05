# frozen_string_literal: true

module FinApps
  module REST
    class PlaidConsumerInstitutions < PlaidResources # :nodoc:
      def create(params)
        super(params, 'p/institution/consumer')
      end

      def list
        super 'p/institution/consumer'
      end
    end
  end
end
