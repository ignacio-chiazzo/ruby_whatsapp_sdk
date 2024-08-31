# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveFooter
      # Returns Text string if the parameter object type is text.
      # For the body interactive, the character limit is 60 characters.
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

      MAXIMUM_LENGTH = 60

      private

      def validate
        validate_text
      end

      def validate_text
        text_length = text.length
        return if text_length <= MAXIMUM_LENGTH

        raise Errors::InvalidInteractiveFooter,
              "Invalid length #{text_length} for text in footer. Maximum length: #{MAXIMUM_LENGTH} characters."
      end
    end
  end
end
