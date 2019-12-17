# frozen_string_literal: true

module FinApps
  module REST
    class VerixMetadata < FinAppsCore::REST::Resources # :nodoc:
      def show
        super nil, 'v/metadata'
      end
    end
  end
end
