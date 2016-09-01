module FinApps
  module Utils
    module ParameterFilter
      PROTECTED_KEYS = %w(login login1 username password password1 password_confirm token).freeze

      def skip_sensitive_data(hash)
        if hash.is_a? Hash
          filtered_hash = hash.clone
          filtered_hash.each do |key, value|
            if PROTECTED_KEYS.include? key.to_s.downcase
              filtered_hash[key] = '[REDACTED]'
            elsif value.is_a?(Hash)
              filtered_hash[key] = skip_sensitive_data(value)
            elsif value.is_a?(Array)
              filtered_hash[key] = value.map {|v| v.is_a?(Hash) ? skip_sensitive_data(v) : v }
            end
          end

          filtered_hash
        else
          hash
        end
      end
    end
  end
end