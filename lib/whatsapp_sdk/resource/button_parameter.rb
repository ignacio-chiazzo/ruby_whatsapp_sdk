# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class ButtonParameter
      class InvalidType < StandardError
        attr_accessor :message

        def initialize(type)
          @message = "invalid type #{type}. type should be text or payload"
          super
        end
      end

      # Returns the button parameter type.
      #
      # @returns type [String] Valid options are payload and text.
      attr_accessor :type

      module Type
        TEXT = "text"
        PAYLOAD = "payload"

        VALID_TYPES = [PAYLOAD, TEXT].freeze
      end

      # Required for quick_reply buttons.
      # Returns the button payload. Developer-defined payload that is returned when the button is clicked
      # in addition to the display text on the button.
      #
      # @returns payload [String]
      attr_accessor :payload

      # Required for URL buttons.
      # Developer-provided suffix that is appended to the predefined prefix URL in the template.
      #
      # @returns text [String]
      attr_accessor :text

      def initialize(type:, payload: nil, text: nil)
        @type = type
        @payload = payload
        @text = text
        validate
      end

      def to_json(*_args)
        json = {
          type: type
        }
        json[:payload] = payload if payload
        json[:text] = text if text
        json
      end

      private

      def validate
        return if Type::VALID_TYPES.include?(type)

        raise InvalidType, type
      end
    end
  end
end
