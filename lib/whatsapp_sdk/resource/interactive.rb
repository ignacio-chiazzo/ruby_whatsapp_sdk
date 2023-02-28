# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Interactive
      extend T::Sig

      class InvalidType < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :message

        sig { params(type: String).void }
        def initialize(type)
          @message = T.let(
            "invalid type #{type} for interactive. type should be list, button, product or product_list.",
            String
          )
          super(message)
        end
      end

      class InvalidActionButtonsCount < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :message

        sig { params(buttons: T::Array[InteractiveActionButton]).void }
        def initialize(buttons)
          @message = T.let(
            "invalid length #{buttons.length} for buttons in action. It should be 1, 2 or 3.",
            String
          )
          super(message)
        end
      end

      class InvalidActionButtonsId < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :message

        sig { params(buttons: T::Array[InteractiveActionButton]).void }
        def initialize(buttons)
          @message = T.let(
            "duplicate ids #{buttons.map(&:id)} for buttons in action. They should be unique.",
            String
          )
          super(message)
        end
      end

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
      attr_reader :type

      # Returns the interactive header if present. Required for type product_list.
      #
      # @returns type [InteractiveHeader] It can be nil.
      sig { returns(T.nilable(InteractiveHeader)) }
      attr_reader :header

      # Returns the interactive body.
      #
      # @returns type [InteractiveBody] Valid option is of type text only.
      sig { returns(InteractiveBody) }
      attr_reader :body

      # Returns the interactive footer if present.
      #
      # @returns type [InteractiveFooter] Valid option is of type text only. It can be nil.
      sig { returns(T.nilable(InteractiveFooter)) }
      attr_reader :footer

      # Returns the interactive action.
      #
      # @returns type [InteractiveBody] Valid condition is buttons of length of 1, 2 or 3 if type is button.
      sig { returns(InteractiveAction) }
      attr_reader :action

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
        json[:body] = body.to_json
        json[:action] = action.to_json
        json[:header] = header.to_json if header
        json[:footer] = footer.to_json if footer

        json
      end

      private

      sig { void }
      def validate
        validate_type
        validate_action
      end

      sig { void }
      def validate_type
        return if Type.valid?(type)

        raise InvalidType, type
      end

      sig { void }
      def validate_action
        raise InvalidActionButtonsCount, action.buttons unless (1..3).include?(action.buttons.length)

        action_button_ids = action.buttons.map(&:id)
        raise InvalidActionButtonsId, action.buttons unless action_button_ids.length.eql?(action_button_ids.uniq.length)
      end
    end
  end
end

