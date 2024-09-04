# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveActionReplyButton
      module Type
        REPLY = "reply"
      end

      # Returns the ActionButton type of message you want to send.
      #
      # @returns type [String]. Supported Options are reply only.
      attr_accessor :type

      # Returns the ActionButton title you want to send.
      #
      # @returns title [String]. The character limit is 20 characters.
      attr_accessor :title

      # Returns the ActionButton unique identifier you want to send.
      # This ID is returned in the webhook when the button is clicked by the user.
      #
      # @returns id [String]. The character limit is 256 characters.
      attr_accessor :id

      ACTION_BUTTON_TITLE_MAXIMUM = 20
      ACTION_BUTTON_ID_MAXIMUM = 256

      def initialize(title:, id:)
        @type = Type::REPLY
        @title = title
        @id = id
        validate
      end

      def to_json
        json = { type: type }
        json[type.to_sym] = {
          id: id,
          title: title
        }

        json
      end

      private

      def validate
        validate_title
        validate_id
      end

      def validate_title
        title_length = title.length
        return if title_length <= ACTION_BUTTON_TITLE_MAXIMUM

        raise Errors::InvalidInteractiveActionReplyButton,
              "Invalid length #{title_length} for title in button. " \
              "Maximum length: #{ACTION_BUTTON_TITLE_MAXIMUM} characters."
      end

      def validate_id
        id_unfrozen = id.dup
        id_unfrozen.strip!  # You cannot have leading or trailing spaces when setting the ID.
        id = id_unfrozen.freeze
        id_length = id.length
        return if id_length <= ACTION_BUTTON_ID_MAXIMUM

        raise Errors::InvalidInteractiveActionReplyButton,
              "Invalid length #{id_length} for id in button. Maximum length: #{ACTION_BUTTON_ID_MAXIMUM} characters."
      end
    end
  end
end
