module FinApps
  module REST
    class OperatorsPasswordResets < FinAppsCore::REST::Resources
      def create(params, path=nil)
        not_blank(params, :params)

        path ||= "operators/password/forgot"

        super params, path
      end
    end
  end
end