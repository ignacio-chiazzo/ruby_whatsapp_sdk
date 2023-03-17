# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveActionSection
      extend T::Sig

      # Returns the ActionSection title you want to send.
      #
      # @returns title [String]. The character limit is 24 characters.
      sig { returns(String) }
      attr_accessor :title

      # Returns the ActionSection rows you want to send.
      #
      # @returns id [T::Array[InteractiveActionSectionRow]]. There must be at least one rows object.
      sig { returns(T::Array[InteractiveActionSectionRow]) }
      attr_accessor :rows

      sig { params(row: InteractiveActionSectionRow).void }
      def add_row(row)
        @rows << row
      end

      ACTION_SECTION_TITLE_MAXIMUM = 24
      ACTION_SECTION_ROWS_MAXIMUM = 10

      sig { params(title: String, rows: T::Array[InteractiveActionSectionRow]).void }
      def initialize(title:, rows: [])
        @title = title
        @rows = rows
        validate(skip_rows: true)
      end

      def to_json
        {
          title: title,
          rows: rows.map(&:to_json)
        }
      end

      sig { params(skip_rows: T.nilable(T::Boolean)).void }
      def validate(skip_rows: false)
        validate_title
        validate_rows unless skip_rows
      end

      private

      sig { void }
      def validate_title
        title_length = title.length
        return if title_length <= ACTION_SECTION_TITLE_MAXIMUM

        raise WhatsappSdk::Resource::Error::InvalidInteractiveActionSection,
              "Invalid length #{title_length} for title in section. Maximum length: " \
              "#{ACTION_SECTION_TITLE_MAXIMUM} characters."
      end

      sig { void }
      def validate_rows
        rows_length = rows.length
        return if rows_length <= ACTION_SECTION_ROWS_MAXIMUM

        raise WhatsappSdk::Resource::Error::InvalidInteractiveActionSection,
              "Invalid number of rows #{rows_length} in section. Maximum count: " \
              "#{ACTION_SECTION_ROWS_MAXIMUM}."
      end
    end
  end
end
