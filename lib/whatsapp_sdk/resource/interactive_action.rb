# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveAction
      extend T::Sig

      class InvalidButtons < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :message

        sig { params(message: String).void }
        def initialize(field, message)
          @message = message
          super(message)
        end
      end

      # button
      # sections
      # catalog_id
      # product_retailer_id

      # Returns the buttons of the Action. For reply_button type, it's required.
      #
      # @returns buttons [Array<InteractiveActionButton>] .
      sig do
       returns(T::Array[InteractiveActionButton])
      end
      attr_accessor :buttons

      REPLY_BUTTONS_MAXIMUM = 3

      sig { params(button: InteractiveActionButton).void }
      def add_button(button)
        @buttons << button
      end

      sig do
        params(buttons: T::Array[InteractiveActionButton]).void
      end
      def initialize(buttons: [])
        @buttons = buttons
        validate
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_json
        json = { buttons: buttons.map(&:to_json) }
        json
      end

      private

      sig { void }
      def validate
        validate_buttons
      end

      sig { void }
      def validate_buttons
        return if buttons.length <= REPLY_BUTTONS_MAXIMUM

        raise InvalidButtons(
          "#{buttons.length} is more than maximum length: #{REPLY_BUTTONS_MAXIMUM}."
        )
      end
    end
  end
end
