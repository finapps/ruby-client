# frozen_string_literal: true

module FinApps
  module REST
    class VerixMetadata < FinAppsCore::REST::Resources # :nodoc:

      def list
        super 'v/metadata'
      end
    end
  end
end