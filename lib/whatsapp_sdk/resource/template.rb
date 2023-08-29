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

      sig { params(id: String, status: Status, category: Category).void }
      def initialize(id:, status:, category:)
        @id = id
        @status = status
        @category = category
      end
    end
  end
end
