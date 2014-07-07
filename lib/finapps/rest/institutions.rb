module FinApps
  module REST

    class Institutions < FinApps::REST::Resources

      # @param [String] term
      # @return [Array<FinApps::REST::Institution>, Array<String>]
      def search(term)
        @logger.debug 'FinApps::REST::Institutions#search => Started'

        # raise MissingArgumentsError.new 'Missing argument: term.' if term.blank?
        @logger.debug "FinApps::REST::Institutions#search => term: #{term}"

        path = END_POINTS[:institutions_search].sub! ':search_term', term.to_s

        institutions, error_messages = @client.get(path) do |r|
          r.body.each { |i| Institution.new(i) }
        end

        @logger.debug 'FinApps::REST::Institutions#search => Completed'
        return institutions, error_messages
      end


    end

    class Institution < FinApps::REST::Resource
      attr_accessor :base_url, :display_name, :site_id, :org_display_name
    end

  end
end