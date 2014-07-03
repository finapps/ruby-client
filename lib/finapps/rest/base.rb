module FinApps
  module REST
    class Base

      # @param [Hash] hash
      def initialize(hash)
        hash.each { |k, v| instance_variable_set("@#{k}", v) unless v.nil? } if hash.present?
        self
      end

    end
  end
end