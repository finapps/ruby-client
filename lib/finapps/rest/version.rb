# frozen_string_literal: true
module FinApps
  module REST
    class Version < FinApps::REST::Resources # :nodoc:
      def show
        super nil, '/version'
      end
    end
  end
end
