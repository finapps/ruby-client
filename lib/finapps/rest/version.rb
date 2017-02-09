# frozen_string_literal: true
module FinApps
  module REST
    class Version < FinAppsCore::REST::Resources # :nodoc:
      def show
        super nil, end_point
      end
    end
  end
end
