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

      sig { params(title: String, rows: T::Array[InteractiveActionSectionRow]).void }
      def initialize(title:, rows: [])
        @title = title
        @rows = rows
        validate
      end

      def to_json
        json = {
          title: title,
          rows: rows.map(&:to_json),
        }

        json
      end

      private

      sig { void }
      def validate
        validate_title
      end

      sig { void }
      def validate_title
        title_length = title.length
        return if title_length <= ACTION_SECTION_TITLE_MAXIMUM

        raise WhatsappSdk::Resource::Error::InvalidInteractiveActionSection.new(
          "Invalid length #{title_length} for title in section. Maximum length: #{ACTION_SECTION_TITLE_MAXIMUM} characters.",
        )
      end
    end
  end
end

