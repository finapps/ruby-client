# frozen_string_literal: true

module FinApps
  module REST
    class ScreeningMetadatas < FinAppsCore::REST::Resources # :nodoc:
      def show(id, key)
        not_blank(id, :session_id)
        not_blank(key, :key)

        path = "screenings/#{ERB::Util.url_encode(id)}/meta/#{ERB::Util.url_encode(key)}"
        super(nil, path)
      end

      def create(id, key, value)
        not_blank(id, :session_id)
        not_blank(key, :key)
        not_blank(value, :value)

        path = "screenings/#{ERB::Util.url_encode(id)}/meta"
        super({key => value}, path)
      end

      def destroy(id, key)
        not_blank(id, :session_id)
        not_blank(key, :key)

        path = "screenings/#{ERB::Util.url_encode(id)}/meta/#{ERB::Util.url_encode(key)}"
        super(nil, path)
      end
    end
  end
end
