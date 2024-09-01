# typed: true
# frozen_string_literal: true

require "test_helper"

module WhatsappSdk
  module Resource
    class InteractionActionTest < Minitest::Test
      def test_validation
        error = assert_raises(Errors::InvalidInteractiveActionButton) do
          interactive_action = InteractiveAction.new(type: InteractiveAction::Type::LIST_MESSAGE)
          interactive_action.validate
        end
        assert_equal(
          "Invalid button in action. Button label is required.",
          error.message
        )

        error = assert_raises(Errors::InvalidInteractiveActionButton) do
          interactive_action = InteractiveAction.new(type: InteractiveAction::Type::LIST_MESSAGE)
          interactive_action.button = "I am the longer CTA button"
          interactive_action.validate
        end
        assert_equal(
          "Invalid length 26 for button. Maximum length: 20 characters.",
          error.message
        )

        error = assert_raises(Errors::InvalidInteractiveActionSection) do
          interactive_action = InteractiveAction.new(type: InteractiveAction::Type::LIST_MESSAGE)
          interactive_action.button = "I am the CTA button"
          interactive_action.validate
        end
        assert_equal(
          "Invalid length 0 for sections in action. It should be between 1 and 10.",
          error.message
        )

        error = assert_raises(Errors::InvalidInteractiveActionReplyButton) do
          interactive_action = InteractiveAction.new(type: InteractiveAction::Type::REPLY_BUTTON)
          interactive_action.validate
        end

        assert_equal(
          "Invalid length 0 for buttons in action. It should be between 1 and 3.",
          error.message
        )

        error = assert_raises(Errors::InvalidInteractiveActionReplyButton) do
          interactive_action = InteractiveAction.new(type: InteractiveAction::Type::REPLY_BUTTON)
          interactive_reply_button_1 = InteractiveActionReplyButton.new(
            title: "I am the button 1",
            id: "button_1"
          )
          interactive_reply_button_2 = InteractiveActionReplyButton.new(
            title: "I am the button 2",
            id: "button_1"
          )
          interactive_action.add_reply_button(interactive_reply_button_1)
          interactive_action.add_reply_button(interactive_reply_button_2)

          interactive_action.validate
        end

        assert_equal(
          "Duplicate ids [\"button_1\", \"button_1\"] for buttons in action. They should be unique.",
          error.message
        )
      end

      def test_to_json_list_message
        interactive_action = InteractiveAction.new(type: InteractiveAction::Type::LIST_MESSAGE)
        interactive_action.button = "I am the CTA button"

        interactive_section = InteractiveActionSection.new(title: "I am the section title")
        interactive_section_row = InteractiveActionSectionRow.new(id: "section_row", title: "I am the row title")
        interactive_section.add_row(interactive_section_row)
        interactive_action.add_section(interactive_section)

        assert_equal(
          {
            button: "I am the CTA button",
            sections: [
              {
                title: "I am the section title",
                rows: [
                  {
                    id: "section_row",
                    title: "I am the row title"
                  }
                ]
              }
            ]
          },
          interactive_action.to_json
        )
      end

      def test_to_json_reply_button
        interactive_action = InteractiveAction.new(type: InteractiveAction::Type::REPLY_BUTTON)
        interactive_reply_button = InteractiveActionReplyButton.new(
          title: "I am the button",
          id: "button"
        )
        interactive_action.add_reply_button(interactive_reply_button)

        assert_equal(
          {
            buttons: [
              {
                type: "reply",
                reply: {
                  id: "button",
                  title: "I am the button"
                }
              }
            ]
          },
          interactive_action.to_json
        )
      end
    end
  end
end
