module FinApps
  module REST
    class Operators < FinAppsCore::REST::Resources
      def list(params=nil)
        return super if params.nil?

        path = "#{endpoint}/#{ERB::Util.url_encode(params)}"
        super path
      end

      def show(id)
        not_blank(id, :operator_id)

        super id
      end

      def create(params, path=nil)
        not_blank(params, :params)
        super params, path
      end

      def update(id, params)
        not_blank(id, :operator_id)
        not_blank(params, :params)

        path = "#{end_point}/#{ERB::Util.url_encode(id)}"
        super params, path
      end

      def update_password(params)
        #update password for current operator, need authorization session in header
        not_blank(params, :params)
        raise FinAppsCore::InvalidArgumentsError.new 'Invalid argument: params.' unless validates params
        path = "#{end_point}/password/change"

        create params, path
      end

      def destroy(id)
        not_blank(id, :operator_id)
        super id
      end

      private

      def validates(params)
        params.key?(:password) && params[:password] && params.key?(:password_confirm) && params[:password_confirm]
      end
    end
  end
end