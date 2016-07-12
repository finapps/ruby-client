module FinApps
  module REST
    class Orders < FinApps::REST::Resources # :nodoc:
      def create(params)
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        super params
      end
    end
  end
end
