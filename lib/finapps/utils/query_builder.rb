# frozen_string_literal: true

module FinApps
  module Utils
    module QueryBuilder
      def query_join(root_url, params_array)
        query_string = params_array.compact.join('&')
        !query_string.empty? ? [root_url, query_string].join('?') : nil
      end
    end
  end
end
