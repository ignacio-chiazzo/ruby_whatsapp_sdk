# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveBody
      # Returns Text string if the parameter object type is text.
      # For the body interactive, the character limit is 1024 characters.
      #
      # @returns text [String]
      attr_accessor :text

      def initialize(text:)
        @text = text
        validate
      end

      def to_json
        { text: text }
      end

      MAXIMUM_LENGTH = 1024

      private

      def validate
        validate_text
      end

      def validate_text
        text_length = text.length
        return if text_length <= MAXIMUM_LENGTH

        raise Errors::InvalidInteractiveBody,
              "Invalid length #{text_length} for text in body. Maximum length: #{MAXIMUM_LENGTH} characters."
      end
    end
  end
end
