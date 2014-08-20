module FinApps
  module REST
    class Resource
      include FinApps::Logging

      # @param [Hash] hash
      def initialize(hash)
        hash.each { |k, v| instance_variable_set("@#{k}", v) unless v.nil? } if hash.present?
        self
      end

    end
  end
end