module FinApps
  module REST
    class OperatorsPasswordResets < FinAppsCore::REST::Resources
      def create(params, path=nil)
        not_blank(params, :params)
        validates_email(params) if path.nil?

        path ||= "operators/password/forgot"

        super params, path
      end

      def update(params)
        not_blank(params, :params)

        path = "operators/password/reset"
        create params, path
      end

      private

      def validates_email(params)
        unless params.key?(:email) && params[:email]
          raise FinAppsCore::InvalidArgumentsError.new 'Invalid argument: params.'
        end
      end
    end
  end
end