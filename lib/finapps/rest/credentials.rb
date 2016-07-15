module FinApps
  module REST
    # represents both tenant and user credentials
    class Credentials
      using ObjectExtensions
      using StringExtensions

      attr_reader :identifier, :token

      def initialize(identifier, token)
        @identifier = identifier
        @token = token
      end

      def valid?
        identifier.present? && token.present?
      end
    end
  end
end
