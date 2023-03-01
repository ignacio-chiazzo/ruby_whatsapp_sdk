# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    module Error
      class MissingValue < WhatsappSdk::Error
        extend T::Sig

        sig { returns(String) }
        attr_reader :field

        sig { returns(String) }
        attr_reader :message

        sig { params(field: String, message: String).void }
        def initialize(field, message)
          @field = field
          @message = message
          super(message)
        end
      end

      class InvalidInteractiveBody < WhatsappSdk::Error; end

      class InvalidInteractiveActionButton < WhatsappSdk::Error; end

      class InvalidInteractiveFooter < WhatsappSdk::Error; end
    end
  end
end
