# frozen_string_literal: true

require_relative "../error"

module WhatsappSdk
  module Resource
    module Errors
      class MissingArgumentError < StandardError
        attr_reader :message

        def initialize(message)
          @message = message
          super(message)
        end
      end

      class MissingValue < Error
        attr_reader :field, :message

        def initialize(field, message)
          @field = field
          @message = message
          super(message)
        end
      end

      class InvalidLanguageError < StandardError
        URL_AVAILABLE_LANGUAGES = "https://developers.facebook.com/docs/whatsapp/api/messages/message-templates"

        attr_reader :language

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
