# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    module Errors
      class MissingArgumentError < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :message

        sig { params(message: String).void }
        def initialize(message)
          @message = message
          super(message)
        end
      end

      class MissingValue < Error
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

      class InvalidLanguageError < StandardError
        extend T::Sig

        URL_AVAILABLE_LANGUAGES = "https://developers.facebook.com/docs/whatsapp/api/messages/message-templates"

        sig { returns(String) }
        attr_reader :language

        sig { params(language: String).void }
        def initialize(language:)
          @language = language

          super("Invalid language. Check the available languages in #{URL_AVAILABLE_LANGUAGES}.")
        end
      end

      class InvalidField < MissingValue; end

      class InvalidInteractiveBody < Error; end

      class InvalidInteractiveActionReplyButton < Error; end

      class InvalidInteractiveActionButton < Error; end

      class InvalidInteractiveActionSection < Error; end

      class InvalidInteractiveActionSectionRow < Error; end

      class InvalidInteractiveFooter < Error; end
    end
  end
end
