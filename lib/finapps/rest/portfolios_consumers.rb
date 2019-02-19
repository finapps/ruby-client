# frozen_string_literal: true

module FinApps
  module REST
    class PortfoliosConsumers < FinAppsCore::REST::Resources
      def list(portfolio_id)
        not_blank(portfolio_id, :portfolio_id)

        super build_path(portfolio_id)
      end

      def create(portfolio_id, params)
        not_blank(portfolio_id, :portfolio_id)
        not_blank(params, :params)

        if params.is_a?(String) # Single Consumer Subscribe
          return super nil, build_path(portfolio_id, params)
        end

        # Array Consumer Subscribe
        super params, build_path(portfolio_id)
      end

      def destroy(portfolio_id, consumer_id)
        not_blank(portfolio_id, :portfolio_id)
        not_blank(consumer_id, :consumer_id)

        # Single Consumer Unsubscribe Only
        super nil, build_path(portfolio_id, consumer_id)
      end

      private

      def build_path(portfolio_id, consumer_id = nil)
        consumer_path = consumer_id ? "consumers/#{ERB::Util.url_encode(consumer_id)}" : 'consumers'
        "portfolios/#{ERB::Util.url_encode(portfolio_id)}/" + consumer_path
      end
    end
  end
end
