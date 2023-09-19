# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Template
      extend T::Sig

      sig { returns(String) }
      attr_accessor :id

      class Status < T::Enum
        extend T::Sig

        enums do
          PENDING_DELETION = new("PENDING_DELETION")
          APPROVED = new("APPROVED")
          PENDING = new("PENDING")
          REJECTED = new("REJECTED")
        end
      end

      sig { returns(Status) }
      attr_accessor :status

      class Category < T::Enum
        extend T::Sig

        enums do
          AUTHENTICATION = new("AUTHENTICATION")
          MARKETING = new("MARKETING")
          UTILITY = new("UTILITY")
        end
      end

      sig { returns(Category) }
      attr_accessor :category

      sig { returns(String) }
      attr_accessor :name

      sig { returns(String) }
      attr_accessor :language

      sig { returns(T::Array[Component]) }
      attr_accessor :components

      sig do
        params(id: String, status: Status, category: Category, name: T.nilable(String), language: String,
               components: T::Array[Component]).void
      end
      def initialize(id:, status:, category:, name: "", language: "en_US", components: [])
        @id = id
        @status = status
        @category = category
        @name = name
        @language = language
        @components = components
      end
    end
  end
end
