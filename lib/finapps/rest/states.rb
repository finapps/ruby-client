# frozen_string_literal: true

module FinApps
  module REST
    class States < FinAppsCore::REST::Resources # :nodoc:
      def end_point
        "references/#{super}"
      end
    end
  end
end
