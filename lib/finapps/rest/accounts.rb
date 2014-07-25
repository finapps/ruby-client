module FinApps
  module REST

    class Accounts < FinApps::REST::Resources
      include FinApps::REST::Defaults

      def list
        logger.debug "##{__method__.to_s} => Started"

        path = Defaults::END_POINTS[:accounts_list]
        logger.debug "##{__method__.to_s} => path: #{path}"

        accounts, error_messages = @client.send(path, :get) do |r|
          r.body.each { |i| Account.new(i) }
        end

        logger.debug "##{__method__.to_s} => Completed"
        return accounts, error_messages
      end

    end

    class Account < FinApps::REST::Resource
      attr_accessor :_id, :institution_name, :account_id, :account_type, :account_name, :account_holder, :account_display_name,
                    :details

      def initialize(hash)
        super
        @details = AccountDetails.new hash[:details]
      end
    end

    class AccountDetails < FinApps::REST::Resource
      attr_accessor :available_balance, :current_balance, :routing_number
    end

  end
end
