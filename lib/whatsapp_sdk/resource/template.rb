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

      sig { returns(T.nilable(String)) }
      attr_accessor :language

      sig { returns(T.nilable(String)) }
      attr_accessor :name

      sig { returns(T.nilable(T::Array[T::Hash[T.untyped, T.untyped]])) }
      attr_accessor :components_json

      sig do
        params(
          id: String, status: Status, category: Category, language: T.nilable(String), name: T.nilable(String),
          components_json: T.nilable(T::Array[T::Hash[T.untyped, T.untyped]])
        ).void
      end
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
