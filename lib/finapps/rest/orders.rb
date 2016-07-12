module FinApps
  module REST
    class Orders < FinApps::REST::Resources # :nodoc:
      def show(id)
        raise MissingArgumentsError.new 'Missing argument: params.' if id.blank?
        super
      end
    end
  end
end
