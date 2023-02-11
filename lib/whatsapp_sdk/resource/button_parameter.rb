# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class ButtonParameter
      extend T::Sig

      # Returns the button parameter type.
      #
      # @returns type [String] Valid options are payload and text.
      sig { returns(Type) }
      attr_accessor :type

      class Type < T::Enum
        extend T::Sig

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
      sig { returns(T.nilable(String)) }
      attr_accessor :payload

      # Required for URL buttons.
      # Developer-provided suffix that is appended to the predefined prefix URL in the template.
      #
      # @returns text [String]
      sig { returns(T.nilable(String)) }
      attr_accessor :text

      sig do
        params(
          type: Type, payload: T.nilable(String), text: T.nilable(String)
        ).void
      end
      def initialize(type:, payload: nil, text: nil)
        @type = type
        @payload = payload
        @text = text
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
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
