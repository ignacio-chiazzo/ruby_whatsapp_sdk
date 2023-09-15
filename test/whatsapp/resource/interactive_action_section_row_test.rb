# typed: true
# frozen_string_literal: true

require "test_helper"

module WhatsappSdk
  module Resource
    class InteractionActionSectionRowTest < Minitest::Test
      def test_validation
        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionSectionRow) do
          WhatsappSdk::Resource::InteractiveActionSectionRow.new(
            title: "I am the longer row title",
            id: "section_row",
            description: "I am the optional section row description"
          )
        end
        assert_equal(
          "Invalid length 25 for title in section row. Maximum length: 24 characters.",
          error.message
        )

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionSectionRow) do
          WhatsappSdk::Resource::InteractiveActionSectionRow.new(
            title: "I am the row title",
            id: "section_row",
            description: "I am the optional section row description " * 2
          )
        end
        assert_equal(
          "Invalid length 84 for description in section row. Maximum length: 72 characters.",
          error.message
        )

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionSectionRow) do
          WhatsappSdk::Resource::InteractiveActionSectionRow.new(
            title: "I am the row title",
            id: "section_row" * 25,
            description: "I am the optional section row description"
          )
        end
        assert_equal(
          "Invalid length 275 for id in section row. Maximum length: 256 characters.",
          error.message
        )
      end

      def test_to_json
        interactive_section_row_1 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
          title: "I am the row title",
          id: "section_row"
        )

        assert_equal(
          {
            id: "section_row",
            title: "I am the row title"
          },
          interactive_section_row_1.to_json
        )

        interactive_section_row_2 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
          title: "I am the row title",
          id: "section_row",
          description: "I am the optional section row description"
        )

        assert_equal(
          {
            id: "section_row",
            title: "I am the row title",
            description: "I am the optional section row description"
          },
          interactive_section_row_2.to_json
        )
      end
    end
  end
end
