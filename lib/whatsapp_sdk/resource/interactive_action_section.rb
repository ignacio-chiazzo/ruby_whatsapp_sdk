# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class InteractiveActionSection
      # Returns the ActionSection title you want to send.
      #
      # @returns title [String]. The character limit is 24 characters.
      attr_accessor :title

      # Returns the ActionSection rows you want to send.
      #
      # @returns an array of InteractiveActionSectionRow. There must be at least one rows object.
      attr_accessor :rows

      def add_row(row)
        @rows << row
      end

      ACTION_SECTION_TITLE_MAXIMUM = 24
      ACTION_SECTION_ROWS_MAXIMUM = 10

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

      def validate(skip_rows: false)
        validate_title
        validate_rows unless skip_rows
      end

      private

      def validate_title
        title_length = title.length
        return if title_length <= ACTION_SECTION_TITLE_MAXIMUM

        raise Errors::InvalidInteractiveActionSection,
              "Invalid length #{title_length} for title in section. Maximum length: " \
              "#{ACTION_SECTION_TITLE_MAXIMUM} characters."
      end

      def validate_rows
        rows_length = rows.length
        return if rows_length <= ACTION_SECTION_ROWS_MAXIMUM

        raise Errors::InvalidInteractiveActionSection,
              "Invalid number of rows #{rows_length} in section. Maximum count: " \
              "#{ACTION_SECTION_ROWS_MAXIMUM}."
      end
    end
  end
end
