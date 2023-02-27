# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveFooter
      extend T::Sig

      class InvalidTextLength < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :message

        sig { params(message: String).void }
        def initialize(message)
          @message = message
          super(message)
        end
      end

      # Returns Text string if the parameter object type is text.
      # For the body interactive, the character limit is 60 characters.
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
        json = { text: text }
        json
      end

      MAXIMUM_LENGTH = 60

      private

      sig { void }
      def validate
        validate_text
      end

      sig { void }
      def validate_text
        raise InvalidTextLength.new(
          "#{text.length} is more than maximum length: 1024 characters."
        ) if text.length > MAXIMUM_LENGTH
      end
    end
  end
end
