# frozen_string_literal: true

module FinApps
  module REST
    class DocumentsUploadTypes < FinAppsCore::REST::Resources
      def list
        super('documents/upload_types')
      end
    end
  end
end
