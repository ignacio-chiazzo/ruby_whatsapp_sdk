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

        # list: Use it for List Messages.
        # button: Use it for Reply Buttons.
        # product: Use it for Single-Product Messages.
        # product_list: Use it for Multi-Product Messages.
        enums do
          ListMessage = new("list")
          ReplyButton = new("button")
          SingleProductMessage = new("product")
          MultiProductMessage = new("product_list")
        end
      end

      # Returns the Interactive type of message you want to send.
      #
      # @returns type [String]. Supported Options are list, button, product and product_list.
      sig { returns(Type) }
      attr_reader :type

      # Returns the interactive header if present. Required for type product_list.
      # ```
      # Header content displayed on top of a message. You cannot set a header if your interactive object is of product type.

      # The header object contains the following fields:

      # documentobject – Required if type is set to document. Contains the media object with the document.

      # imageobject – Required if type is set to image. Contains the media object with the image.

      # videoobject – Required if type is set to video. Contains the media object with the video.

      # textstring – Required if type is set to text. Text for the header. Formatting allows emojis, but not markdown. Maximum length: 60 characters.

      # typestring – Required. The header type you would like to use. Supported values are:

      # text – for List Messages, Reply Buttons, and Multi-Product Messages.

      # video – for Reply Buttons.

      # image – for Reply Buttons.

      # document – for Reply Buttons.
      # ```
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
      # @returns type [InteractiveBody] Valid condition is of length of 1, 2 or 3.
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

