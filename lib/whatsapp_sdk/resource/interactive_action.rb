# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveAction
      extend T::Sig

      # Returns the buttons of the Action. For reply_button type, it's required.
      #
      # @returns buttons [Array<InteractiveActionReplyButton>] .
      sig do
        returns(T::Array[InteractiveActionReplyButton])
      end
      attr_accessor :buttons

      # TODO: attr_accessor :button
      # TODO: attr_accessor :sections
      # TODO: attr_accessor :catalog_id
      # TODO: attr_accessor :product_retailer_id

      sig { params(button: InteractiveActionReplyButton).void }
      def add_button(button)
        @buttons << button
      end

      sig do
        params(buttons: T::Array[InteractiveActionReplyButton]).void
      end
      def initialize(buttons: [])
        @buttons = buttons
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_json
        { buttons: buttons.map(&:to_json) }
      end
    end
  end
end
