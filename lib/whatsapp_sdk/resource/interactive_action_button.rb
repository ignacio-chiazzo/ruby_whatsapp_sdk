# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveActionButton
      extend T::Sig

      class InvalidType < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :message

        sig { params(type: String).void }
        def initialize(type)
          @message = T.let(
            "invalid type #{type} for interactive. type should be reply only.",
            String
          )
          super(message)
        end
      end

      class InvalidTitle < StandardError
        extend T::Sig

        sig { returns(String) }
        attr_reader :message

        sig { params(length: Integer).void }
        def initialize(length)
          @message = T.let(
            "#{length} is not allowed. Maximum length: #{ACTION_BUTTON_TITLE_MAXIMUM} characters.",
            String
          )
          super(message)
        end
      end

      class Type < T::Enum
        extend T::Sig

        enums do
          Reply = new("reply")
        end
      end

      # Returns the ActionButton type of message you want to send.
      #
      # @returns type [String]. Supported Options are reply only.
      sig { returns(Type) }
      attr_reader :type

      # Returns the ActionButton title you want to send.
      #
      # @returns title [String]. The character limit is 20 characters.
      sig { returns(String) }
      attr_reader :title

      # Returns the ActionButton unique identifier you want to send.
      # This ID is returned in the webhook when the button is clicked by the user.
      #
      # @returns id [String]. The character limit is 256 characters.
      sig { returns(T.nilable(String)) }
      attr_reader :id

      ACTION_BUTTON_TITLE_MAXIMUM = 20
      ACTION_BUTTON_ID_MAXIMUM = 256

      sig { params(type: Type, title: String, id: T.nilable(String)).void }
      def initialize(type:, title:, id: nil)
        @type = type
        @title = title
        @id = id
        validate
      end

      def to_json
        json = { type: type.serialize }
        json[type.serialize] = {
          title: title,
        }
        json[type.serialize][:id] = id if id

        json
      end

      private

      sig { void }
      def validate
        validate_type
        validate_title
        validate_id
      end

      sig { void }
      def validate_type
        return if [Type::Reply].include?(type)

        raise InvalidType, type
      end

      sig { void }
      def validate_title
        return if title.length <= ACTION_BUTTON_TITLE_MAXIMUM

        raise InvalidTitle, title.length
      end

      sig { void }
      def validate_id
        return unless id

        # TODO: Fix sorbet complaining NoMethodError for nil
        id = id.dup
        id.strip!  if id # You cannot have leading or trailing spaces when setting the ID.
        return if id&.length.to_i <= ACTION_BUTTON_ID_MAXIMUM

        raise InvalidId, id.length
      end
    end
  end
end

