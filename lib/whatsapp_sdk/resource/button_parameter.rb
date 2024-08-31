# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class ButtonParameter

      # Returns the button parameter type.
      #
      # @returns type [String] Valid options are payload and text.
      attr_accessor :type

      class Type < T::Enum
        enums do
          Text = new("text")
          Payload = new("payload")
        end
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
      end

      def to_json
        json = {
          type: type.serialize
        }
        json[:payload] = payload if payload
        json[:text] = text if text
        json
      end
    end
  end
end
