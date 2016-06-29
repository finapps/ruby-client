module FinApps
  # when included into any object, allows to initialize public attributes from a hash
  module HashConstructable
    def initialize(options_hash={}, defaults=nil)
      merged_hash = defaults.nil? ? options_hash : defaults.merge(options_hash.compact)
      merged_hash.each {|k, v| public_send("#{k}=", v) }
    end
  end
end
