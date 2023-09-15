# typed: true
# frozen_string_literal: true

require "test_helper"
require 'resource/interactive'
require 'resource/interactive_action'
require 'resource/interactive_action_reply_button'
require 'resource/interactive_action_section'
require 'resource/interactive_action_section_row'
require 'resource/interactive_body'
require 'resource/interactive_footer'
require 'resource/interactive_header'

module WhatsappSdk
  module Resource
    class InteractiveTest < Minitest::Test
      def test_validation_reply_buttons
        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionReplyButton) do
          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(text: "This is the body!")
          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ReplyButton
          )
          interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 1",
            id: "button_1"
          )
          interactive_reply_button_2 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 2",
            id: "button_2"
          )
          interactive_reply_button_3 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 3",
            id: "button_3"
          )
          interactive_reply_button_4 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 4",
            id: "button_4"
          )
          interactive_action.add_reply_button(interactive_reply_button_1)
          interactive_action.add_reply_button(interactive_reply_button_2)
          interactive_action.add_reply_button(interactive_reply_button_3)
          interactive_action.add_reply_button(interactive_reply_button_4)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ReplyButton,
            body: interactive_body,
            action: interactive_action
          )
        end
        assert_equal("Invalid length 4 for buttons in action. It should be between 1 and 3.", error.message)

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionReplyButton) do
          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(text: "This is the body!")
          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ReplyButton
          )
          interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 1",
            id: "button_1"
          )
          interactive_reply_button_2 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 2",
            id: "button_1"
          )
          interactive_action.add_reply_button(interactive_reply_button_1)
          interactive_action.add_reply_button(interactive_reply_button_2)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ReplyButton,
            body: interactive_body,
            action: interactive_action
          )
        end
        assert_equal("Duplicate ids [\"button_1\", \"button_1\"] for buttons in action. They should be unique.",
                     error.message)

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionReplyButton) do
          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(text: "This is the body!")
          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ReplyButton
          )
          interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the longer button 1",
            id: "button_1"
          )
          interactive_action.add_reply_button(interactive_reply_button_1)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ReplyButton,
            body: interactive_body,
            action: interactive_action
          )
        end
        assert_equal("Invalid length 24 for title in button. Maximum length: 20 characters.", error.message)

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionReplyButton) do
          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(text: "This is the body!")
          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ReplyButton
          )
          interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 1",
            id: "button_1 " * 32
          )
          interactive_action.add_reply_button(interactive_reply_button_1)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ReplyButton,
            body: interactive_body,
            action: interactive_action
          )
        end
        assert_equal("Invalid length 287 for id in button. Maximum length: 256 characters.", error.message)

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveFooter) do
          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(text: "This is the body!")
          interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(text: "Footer " * 10)
          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ReplyButton
          )
          interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 1",
            id: "button_1"
          )
          interactive_reply_button_2 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 2",
            id: "button_2"
          )
          interactive_reply_button_3 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 3",
            id: "button_3"
          )
          interactive_action.add_reply_button(interactive_reply_button_1)
          interactive_action.add_reply_button(interactive_reply_button_2)
          interactive_action.add_reply_button(interactive_reply_button_3)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ReplyButton,
            body: interactive_body,
            footer: interactive_footer,
            action: interactive_action
          )
        end
        assert_equal("Invalid length 70 for text in footer. Maximum length: 60 characters.", error.message)

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveBody) do
          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(text: "Body " * 250)
          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ReplyButton
          )
          interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 1",
            id: "button_1"
          )
          interactive_reply_button_2 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 2",
            id: "button_2"
          )
          interactive_reply_button_3 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
            title: "I am the button 3",
            id: "button_3"
          )
          interactive_action.add_reply_button(interactive_reply_button_1)
          interactive_action.add_reply_button(interactive_reply_button_2)
          interactive_action.add_reply_button(interactive_reply_button_3)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ReplyButton,
            body: interactive_body,
            action: interactive_action
          )
        end
        assert_equal("Invalid length 1250 for text in body. Maximum length: 1024 characters.", error.message)
      end

      def test_validation_list_messages
        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionButton) do
          interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(
            type: WhatsappSdk::Resource::InteractiveHeader::Type::Text,
            text: "I am the header!"
          )

          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(
            text: "I am the body!"
          )

          interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(
            text: "I am the footer!"
          )

          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ListMessage
          )

          interactive_section_1 = WhatsappSdk::Resource::InteractiveActionSection.new(
            title: "I am the section 1"
          )
          interactive_section_1_row_1 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
            title: "I am the row 1 title",
            id: "section_1_row_1",
            description: "I am the optional section 1 row 1 description"
          )
          interactive_section_1.add_row(interactive_section_1_row_1)
          interactive_action.add_section(interactive_section_1)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ListMessage,
            header: interactive_header,
            body: interactive_body,
            footer: interactive_footer,
            action: interactive_action
          )
        end
        assert_equal("Invalid button in action. Button label is required.", error.message)

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionSection) do
          interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(
            type: WhatsappSdk::Resource::InteractiveHeader::Type::Text,
            text: "I am the header!"
          )

          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(
            text: "I am the body!"
          )

          interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(
            text: "I am the footer!"
          )

          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ListMessage
          )

          interactive_action.button = "I am the button CTA"

          interactive_section_1 = WhatsappSdk::Resource::InteractiveActionSection.new(
            title: "I am the longer section 1"
          )
          interactive_section_1_row_1 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
            title: "I am the row 1 title",
            id: "section_1_row_1",
            description: "I am the optional section 1 row 1 description"
          )
          interactive_section_1.add_row(interactive_section_1_row_1)
          interactive_action.add_section(interactive_section_1)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ListMessage,
            header: interactive_header,
            body: interactive_body,
            footer: interactive_footer,
            action: interactive_action
          )
        end
        assert_equal("Invalid length 25 for title in section. Maximum length: 24 characters.", error.message)

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionSection) do
          interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(
            type: WhatsappSdk::Resource::InteractiveHeader::Type::Text,
            text: "I am the header!"
          )

          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(
            text: "I am the body!"
          )

          interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(
            text: "I am the footer!"
          )

          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ListMessage
          )

          interactive_action.button = "I am the button CTA"

          interactive_section_1 = WhatsappSdk::Resource::InteractiveActionSection.new(
            title: "I am the section 1"
          )
          11.times do |i|
            interactive_section_row = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
              title: "I am the row #{i} title",
              id: "section_1_row_#{i}",
              description: "I am the optional section 1 row #{i} description"
            )
            interactive_section_1.add_row(interactive_section_row)
          end
          interactive_action.add_section(interactive_section_1)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ListMessage,
            header: interactive_header,
            body: interactive_body,
            footer: interactive_footer,
            action: interactive_action
          )
        end
        assert_equal("Invalid number of rows 11 in section. Maximum count: 10.", error.message)

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionSectionRow) do
          interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(
            type: WhatsappSdk::Resource::InteractiveHeader::Type::Text,
            text: "I am the header!"
          )

          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(
            text: "I am the body!"
          )

          interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(
            text: "I am the footer!"
          )

          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ListMessage
          )

          interactive_action.button = "I am the button CTA"

          interactive_section_1 = WhatsappSdk::Resource::InteractiveActionSection.new(
            title: "I am the section 1"
          )
          interactive_section_1_row_1 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
            title: "I am the longer row 1 title",
            id: "section_1_row_1",
            description: "I am the optional section 1 row 1 description"
          )
          interactive_section_1.add_row(interactive_section_1_row_1)
          interactive_action.add_section(interactive_section_1)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ListMessage,
            header: interactive_header,
            body: interactive_body,
            footer: interactive_footer,
            action: interactive_action
          )
        end
        assert_equal("Invalid length 27 for title in section row. Maximum length: 24 characters.", error.message)

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionSectionRow) do
          interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(
            type: WhatsappSdk::Resource::InteractiveHeader::Type::Text,
            text: "I am the header!"
          )

          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(
            text: "I am the body!"
          )

          interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(
            text: "I am the footer!"
          )

          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ListMessage
          )

          interactive_action.button = "I am the button CTA"

          interactive_section_1 = WhatsappSdk::Resource::InteractiveActionSection.new(
            title: "I am the section 1"
          )
          interactive_section_1_row_1 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
            title: "I am the row 1 title",
            id: "section_1_row_1 " * 20,
            description: "I am the optional section 1 row 1 description"
          )
          interactive_section_1.add_row(interactive_section_1_row_1)
          interactive_action.add_section(interactive_section_1)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ListMessage,
            header: interactive_header,
            body: interactive_body,
            footer: interactive_footer,
            action: interactive_action
          )
        end
        assert_equal("Invalid length 319 for id in section row. Maximum length: 256 characters.", error.message)

        error = assert_raises(WhatsappSdk::Resource::Errors::InvalidInteractiveActionSectionRow) do
          interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(
            type: WhatsappSdk::Resource::InteractiveHeader::Type::Text,
            text: "I am the header!"
          )

          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(
            text: "I am the body!"
          )

          interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(
            text: "I am the footer!"
          )

          interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
            type: WhatsappSdk::Resource::InteractiveAction::Type::ListMessage
          )

          interactive_action.button = "I am the button CTA"

          interactive_section_1 = WhatsappSdk::Resource::InteractiveActionSection.new(
            title: "I am the section 1"
          )
          interactive_section_1_row_1 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
            title: "I am the row 1 title",
            id: "section_1_row_1",
            description: "I am the optional section 1 row 1 description " * 2
          )
          interactive_section_1.add_row(interactive_section_1_row_1)
          interactive_action.add_section(interactive_section_1)

          WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ListMessage,
            header: interactive_header,
            body: interactive_body,
            footer: interactive_footer,
            action: interactive_action
          )
        end
        assert_equal("Invalid length 92 for description in section row. Maximum length: 72 characters.", error.message)
      end

      def test_to_json_reply_buttons
        interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(
          type: WhatsappSdk::Resource::InteractiveHeader::Type::Text,
          text: "I am the header!"
        )

        interactive_body = WhatsappSdk::Resource::InteractiveBody.new(
          text: "I am the body!"
        )

        interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(
          text: "I am the footer!"
        )

        interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
          type: WhatsappSdk::Resource::InteractiveAction::Type::ReplyButton
        )

        interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
          title: "I am the button 1",
          id: "button_1"
        )
        interactive_action.add_reply_button(interactive_reply_button_1)

        interactive_reply_button_2 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
          title: "I am the button 2",
          id: "button_2"
        )
        interactive_action.add_reply_button(interactive_reply_button_2)

        interactive_reply_buttons = WhatsappSdk::Resource::Interactive.new(
          type: WhatsappSdk::Resource::Interactive::Type::ReplyButton,
          header: interactive_header,
          body: interactive_body,
          footer: interactive_footer,
          action: interactive_action
        )

        assert_equal(
          {
            type: "button",
            header: {
              type: "text",
              text: "I am the header!"
            },
            body: {
              text: "I am the body!"
            },
            footer: {
              text: "I am the footer!"
            },
            action: {
              buttons: [
                {
                  type: "reply",
                  reply: {
                    title: "I am the button 1",
                    id: "button_1"
                  }
                },
                {
                  type: "reply",
                  reply: {
                    title: "I am the button 2",
                    id: "button_2"
                  }
                }
              ]
            }
          },
          interactive_reply_buttons.to_json
        )
      end

      def test_to_json_list_messages
        interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(
          type: WhatsappSdk::Resource::InteractiveHeader::Type::Text,
          text: "I am the header!"
        )

        interactive_body = WhatsappSdk::Resource::InteractiveBody.new(
          text: "I am the body!"
        )

        interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(
          text: "I am the footer!"
        )

        interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
          type: WhatsappSdk::Resource::InteractiveAction::Type::ListMessage
        )

        interactive_action.button = "I am the button CTA"

        interactive_section_1 = WhatsappSdk::Resource::InteractiveActionSection.new(
          title: "I am the section 1"
        )
        interactive_section_1_row_1 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
          title: "I am the row 1 title",
          id: "section_1_row_1",
          description: "I am the optional section 1 row 1 description"
        )
        interactive_section_1.add_row(interactive_section_1_row_1)
        interactive_action.add_section(interactive_section_1)

        interactive_list_messages = WhatsappSdk::Resource::Interactive.new(
          type: WhatsappSdk::Resource::Interactive::Type::ListMessage,
          header: interactive_header,
          body: interactive_body,
          footer: interactive_footer,
          action: interactive_action
        )

        assert_equal(
          {
            type: "list",
            header: {
              type: "text",
              text: "I am the header!"
            },
            body: {
              text: "I am the body!"
            },
            footer: {
              text: "I am the footer!"
            },
            action: {
              button: "I am the button CTA",
              sections: [
                {
                  title: "I am the section 1",
                  rows: [
                    {
                      id: "section_1_row_1",
                      title: "I am the row 1 title",
                      description: "I am the optional section 1 row 1 description"
                    }
                  ]
                }
              ]
            }
          },
          interactive_list_messages.to_json
        )
      end
    end
  end
end
