# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Template
      extend T::Sig

      class Status < T::Enum
        extend T::Sig

        enums do
          PENDING_DELETION = new("PENDING_DELETION")
          APPROVED = new("APPROVED")
          PENDING = new("PENDING")
          REJECTED = new("REJECTED")
        end
      end

      class Category < T::Enum
        extend T::Sig

        enums do
          AUTHENTICATION = new("AUTHENTICATION")
          MARKETING = new("MARKETING")
          UTILITY = new("UTILITY")
        end
      end
    end
  end
end
