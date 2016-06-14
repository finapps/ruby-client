module FinApps
  module REST

    require 'erb'

    class Institutions < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @param [String] term
      # @return [Array<FinApps::REST::Institution>, Array<String>]
      def search(term)
        raise MissingArgumentsError.new 'Missing argument: term.' if term.blank?
        logger.debug "##{__method__.to_s} => term: #{term}"

        end_point = Defaults::END_POINTS[:institutions_list]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':search_term', ERB::Util.url_encode(term)
        logger.debug "##{__method__.to_s} => path: #{path}"

        institutions, error_messages = @client.send_request(path, :get)
        return institutions, error_messages
      end

      # @param [Integer] site_id
      def form(site_id)
        raise MissingArgumentsError.new 'Missing argument: site_id.' if site_id.blank?
        logger.debug "##{__method__.to_s} => site_id: #{site_id}"

        end_point = Defaults::END_POINTS[:institutions_form]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':site_id', ERB::Util.url_encode(site_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        institution, error_messages = @client.send_request(path, :get) { |r| Institution.new(r.body) }
        return institution, error_messages
      end

    end

    class Institution < FinApps::REST::Resource
      attr_accessor :login_form_html
    end

  end
end