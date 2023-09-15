# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveBody
      extend T::Sig

      # Returns Text string if the parameter object type is text.
      # For the body interactive, the character limit is 1024 characters.
      #
      # @returns text [String]
      sig { returns(String) }
      attr_accessor :text

      sig do
        params(text: String).void
      end
      def initialize(text:)
        @text = text
        validate
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_json
        { text: text }
      end

      MAXIMUM_LENGTH = 1024

      private

      sig { void }
      def validate
        validate_text
      end

      sig { void }
      def validate_text
        text_length = text.length
        return if text_length <= MAXIMUM_LENGTH

        raise Errors::InvalidInteractiveBody,
              "Invalid length #{text_length} for text in body. Maximum length: #{MAXIMUM_LENGTH} characters."
      end
    end
  end
end
