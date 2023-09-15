# typed: true
# frozen_string_literal: true

require "test_helper"

module WhatsappSdk
  module Resource
    class InteractionActionSectionTest < Minitest::Test
      def test_validation
        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionSection) do
          WhatsappSdk::Resource::InteractiveActionSection.new(
            title: "I am the longer section title"
          )
        end
        assert_equal(
          "Invalid length 29 for title in section. Maximum length: 24 characters.",
          error.message
        )
      end

      def test_to_json
        interactive_section = WhatsappSdk::Resource::InteractiveActionSection.new(
          title: "I am the section"
        )
        interactive_section_row_1 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
          title: "I am the row 1 title",
          id: "section_row_1",
          description: "I am the optional section row 1 description"
        )
        interactive_section_row_2 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
          title: "I am the row 2 title",
          id: "section_row_2",
          description: "I am the optional section row 2 description"
        )
        interactive_section.add_row(interactive_section_row_1)
        interactive_section.add_row(interactive_section_row_2)

        assert_equal(
          {
            title: "I am the section",
            rows: [
              {
                id: "section_row_1",
                title: "I am the row 1 title",
                description: "I am the optional section row 1 description"
              },
              {
                id: "section_row_2",
                title: "I am the row 2 title",
                description: "I am the optional section row 2 description"
              }
            ]
          },
          interactive_section.to_json
        )
      end
    end
  end
end
