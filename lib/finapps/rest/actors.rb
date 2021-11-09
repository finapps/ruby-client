# frozen_string_literal: true

module FinApps
  module REST
    class Actors < FinAppsCore::REST::Resources
      END_POINT = 'actor/details'

      def show
        super nil, END_POINT
      end
    end
  end
end
