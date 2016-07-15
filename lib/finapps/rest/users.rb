# frozen_string_literal: true
module FinApps
  module REST
    class Users < FinApps::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      END_POINTS = {
        list:    nil,
        create:  'users/new',
        show:    'users/:public_id',
        update:  'user',
        destroy: 'users/:public_id'
      }.freeze

      # @param [String] public_id
      # @return [FinApps::REST::User, Array<String>]
      def show(public_id)
        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?

        end_point = END_POINTS[:show]
        path = end_point.sub ':public_id', ERB::Util.url_encode(public_id)

        logger.debug "##{__method__} => path: #{path}"

        results, error_messages = client.send_request(path, :get)
        [results, error_messages]
      end

      # @param [Hash] params
      # @return [Array<String>]
      def update(params)
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__} => params: #{params}"

        end_point = END_POINTS[:update]
        path = end_point

        logger.debug "##{__method__} => path: #{path}"

        results, error_messages = client.send_request(path, :put, params.compact)
        [results, error_messages]
      end

      # @param [String] public_id
      # @return [Array<String>]
      def delete(public_id)
        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?
        logger.debug "##{__method__} => public_id: #{public_id}"

        end_point = END_POINTS[:delete]
        logger.debug "##{__method__} => end_point: #{end_point}"

        path = end_point.sub ':public_id', ERB::Util.url_encode(public_id)
        logger.debug "##{__method__} => path: #{path}"

        results, error_messages = client.send_request(path, :delete)
        [results, error_messages]
      end
    end
  end
end
