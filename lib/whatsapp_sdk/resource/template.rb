# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Template
      class Status < T::Enum
        enums do
          PENDING_DELETION = new("PENDING_DELETION")
          APPROVED = new("APPROVED")
          PENDING = new("PENDING")
          REJECTED = new("REJECTED")
        end
      end

      class Category < T::Enum
        enums do
          AUTHENTICATION = new("AUTHENTICATION")
          MARKETING = new("MARKETING")
          UTILITY = new("UTILITY")
        end
      end

      attr_accessor :id,:status, :category, :language, :name, :components_json

      def initialize(id:, status:, category:, language: nil, name: nil, components_json: nil)
        @id = id
        @status = status
        @category = category
        @language = language
        @name = name
        @components_json = components_json
      end
    end
  end
end
