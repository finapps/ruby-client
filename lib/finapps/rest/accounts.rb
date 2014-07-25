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

      def show(account_id)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: account_id.' if account_id.blank?
        logger.debug "##{__method__.to_s} => site_id: #{site_id}"

        end_point = Defaults::END_POINTS[:accounts_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':account_id', ERB::Util.url_encode(account_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        account, error_messages = @client.send(path, :get ) do |r|
          Account.new(r.body)
        end

        logger.debug "##{__method__.to_s} => Completed"
        return account, error_messages
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
