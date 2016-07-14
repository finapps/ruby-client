module FinApps
  module REST
    class Orders < FinApps::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def show(id)
        raise MissingArgumentsError.new 'Missing argument: params.' if id.blank?
        super
      end
    end
  end
end
