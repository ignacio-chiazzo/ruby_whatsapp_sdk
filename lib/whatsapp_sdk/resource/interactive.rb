# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Interactive
      module Type
        LIST_MESSAGE = "list"
        REPLY_BUTTON = "button"
        SINGLE_PRODUCT_MESSAGE = "product"
        MULTI_PRODUCT_MESSAGE = "product_list"
      end

      # Returns the Interactive type of message you want to send.
      #
      # @returns type [Type]. Supported Options are list, button, product and product_list.
      attr_accessor :type

      # Returns the interactive header if present. Required for type product_list.
      #
      # @returns type [InteractiveHeader] It can be nil.
      attr_accessor :header

      # Returns the interactive body.
      #
      # @returns type [InteractiveBody] Valid option is of type text only.
      attr_accessor :body

      # Returns the interactive footer if present.
      #
      # @returns type [InteractiveFooter] Valid option is of type text only. It can be nil.
      attr_accessor :footer

      # Returns the interactive action.
      #
      # @returns type [InteractiveBody] Valid condition is buttons of length of 1, 2 or 3 if type is button.
      attr_accessor :action

      def initialize(type:, body:, action:, header: nil, footer: nil)
        @type = type
        @body = body
        @action = action
        @header = header
        @footer = footer
        validate
      end

      def to_json
        json = { type: type }
        json[:header] = header.to_json if header
        json[:body] = body.to_json
        json[:footer] = footer.to_json if footer
        json[:action] = action.to_json

        json
      end

      private

      def validate
        validate_action
      end

      def validate_action
        action.validate
      end
    end
  end
end
