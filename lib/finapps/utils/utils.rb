class Object
  # An object is blank if it's false, empty, or a whitespace string.
  # For example, "", "   ", +nil+, [], and {} are all blank.
  #
  # This simplifies:
  #
  #   if address.nil? || address.empty?
  #
  # ...to:
  #
  #   if address.blank?
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  # An object is present if it's not <tt>blank?</tt>.
  def present?
    !blank?
  end

  # Returns object if it's <tt>present?</tt> otherwise returns +nil+.
  # <tt>object.presence</tt> is equivalent to <tt>object.present? ? object : nil</tt>.
  #
  # This is handy for any representation of objects where blank is the same
  # as not present at all. For example, this simplifies a common check for
  # HTTP POST/query parameters:
  #
  #   state   = params[:state]   if params[:state].present?
  #   country = params[:country] if params[:country].present?
  #   region  = state || country || 'US'
  #
  # ...becomes:
  #
  #   region = params[:state].presence || params[:country].presence || 'US'
  def presence
    self if present?
  end

  def trim
    respond_to?(:strip) ? self.strip : self
  end
end

class Hash
  def validate_required_strings!
    self.each do |key, value|
      raise MissingArgumentsError.new "Missing argument: #{key}." if value.blank?
      raise InvalidArgumentsError.new "Invalid #{key} specified: #{value.inspect} must be a string or symbol." unless value.is_a?(String) || value.is_a?(Symbol)
    end
  end

  def compact
    self.delete_if { |_, v| v.nil? }
  end
end