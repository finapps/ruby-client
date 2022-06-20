# frozen_string_literal: true

module Fake
  module QueryUserRoutes
    class << self
      def included(base)
        base.post("/#{base.version}/query/users") do
          json_response 200, 'query/users.json'
        end
        super
      end
    end
  end
end
