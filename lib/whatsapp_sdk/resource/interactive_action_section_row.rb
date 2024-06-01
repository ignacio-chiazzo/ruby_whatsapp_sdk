# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveActionSectionRow
      extend T::Sig

      # Returns the ActionSection title you want to send.
      #
      # @returns title [String]. The character limit is 24 characters.
      sig { returns(String) }
      attr_accessor :title

      # Returns the ActionSection description you want to send.
      #
      # @returns description [String]. The character limit is 72 characters if present.
      sig { returns(T.nilable(String)) }
      attr_accessor :description

      # Returns the ActionSection unique identifier you want to send.
      # This ID is returned in the webhook when the section is selected by the user.
      #
      # @returns id [String]. The character limit is 256 characters.
      sig { returns(String) }
      attr_accessor :id

      ACTION_SECTION_TITLE_MAXIMUM = 24
      ACTION_SECTION_DESCRIPTION_MAXIMUM = 72
      ACTION_SECTION_ID_MAXIMUM = 256

      sig { params(title: String, id: String, description: T.nilable(String)).void }
      def initialize(title:, id:, description: "")
        @title = title
        @id = id
        @description = description
        validate
      end

      sig { returns(String) }
      def to_json
        json = {
          id: id,
          title: title
        }
        json[:description] = description if description.length.positive?

        json
      end

      private

      sig { void }
      def validate
        validate_title
        validate_id
        validate_description
      end

      sig { void }
      def validate_title
        title_length = title.length
        return if title_length <= ACTION_SECTION_TITLE_MAXIMUM

        raise Errors::InvalidInteractiveActionSectionRow,
              "Invalid length #{title_length} for title in section row. " \
              "Maximum length: #{ACTION_SECTION_TITLE_MAXIMUM} characters."
      end

      sig { void }
      def validate_id
        id_unfrozen = id.dup
        id_unfrozen.strip!  # You cannot have leading or trailing spaces when setting the ID.
        id = id_unfrozen.freeze
        id_length = id.length
        return if id_length <= ACTION_SECTION_ID_MAXIMUM

        raise Errors::InvalidInteractiveActionSectionRow,
              "Invalid length #{id_length} for id in section row. Maximum length: " \
              "#{ACTION_SECTION_ID_MAXIMUM} characters."
      end

      sig { void }
      def validate_description
        description_length = description.length
        return if description_length <= ACTION_SECTION_DESCRIPTION_MAXIMUM

        raise Errors::InvalidInteractiveActionSectionRow,
              "Invalid length #{description_length} for description in section " \
              "row. Maximum length: #{ACTION_SECTION_DESCRIPTION_MAXIMUM} characters."
      end
    end
  end
end
