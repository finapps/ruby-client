# frozen_string_literal: true

module FinApps
  module REST
    module Query
      class Base < FinAppsCore::REST::Resources
        def end_point
          "query/#{super}"
        end
      end
    end
  end
end
