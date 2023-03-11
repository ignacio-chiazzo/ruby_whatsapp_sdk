# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Interactive
      extend T::Sig

      class Type < T::Enum
        extend T::Sig

        enums do
          ListMessage = new("list")
          ReplyButton = new("button")
          SingleProductMessage = new("product")
          MultiProductMessage = new("product_list")
        end
      end

      # Returns the Interactive type of message you want to send.
      #
      # @returns type [Type]. Supported Options are list, button, product and product_list.
      sig { returns(Type) }
      attr_accessor :type

      # Returns the interactive header if present. Required for type product_list.
      #
      # @returns type [InteractiveHeader] It can be nil.
      sig { returns(T.nilable(InteractiveHeader)) }
      attr_accessor :header

      # Returns the interactive body.
      #
      # @returns type [InteractiveBody] Valid option is of type text only.
      sig { returns(InteractiveBody) }
      attr_accessor :body

      # Returns the interactive footer if present.
      #
      # @returns type [InteractiveFooter] Valid option is of type text only. It can be nil.
      sig { returns(T.nilable(InteractiveFooter)) }
      attr_accessor :footer

      # Returns the interactive action.
      #
      # @returns type [InteractiveBody] Valid condition is buttons of length of 1, 2 or 3 if type is button.
      sig { returns(InteractiveAction) }
      attr_accessor :action

      sig do
        params(
          type: Type, body: InteractiveBody, action: InteractiveAction,
          header: T.nilable(InteractiveHeader), footer: T.nilable(InteractiveFooter)
        ).void
      end
      def initialize(type:, body:, action:, header: nil, footer: nil)
        @type = type
        @body = body
        @action = action
        @header = header
        @footer = footer
        validate
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_json
        json = { type: type.serialize }
        json[:header] = header.to_json if header
        json[:body] = body.to_json
        json[:footer] = footer.to_json if footer
        json[:action] = action.to_json

        json
      end

      private

      sig { void }
      def validate
        validate_action
      end

      sig { void }
      def validate_action
        action.send(:validate)
      end
    end
  end
end
