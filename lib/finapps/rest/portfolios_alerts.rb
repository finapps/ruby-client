# frozen_string_literal: true

module FinApps
  module REST
    class PortfoliosAlerts < FinAppsCore::REST::Resources

      def list(portfolio_id)
        not_blank(portfolio_id, :portfolio_id)

        super build_path(portfolio_id)
      end

      def create(portfolio_id, alert_id, params)
        not_blank(portfolio_id, :portfolio_id)
        not_blank(alert_id, :alert_id)

        update params, build_path(portfolio_id, alert_id)
      end

      def delete(portfolio_id, alert_id)
        not_blank(portfolio_id, :portfolio_id)
        not_blank(alert_id, :alert_id)

        delete nil, build_path(portfolio_id, alert_id)
      end

      private

      def build_path(portfolio_id, alert_id = nil)
        alert_path = alert_id ? "alerts/#{ERB::Util.url_encode(alert_id)}" : "alerts"
        return "portfolios/#{ERB::Util.url_encode(portfolio_id)}/" + alert_path
      end
    end
  end
end
