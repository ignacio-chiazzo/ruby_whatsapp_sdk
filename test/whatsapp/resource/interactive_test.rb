# typed: true
# frozen_string_literal: true

require "test_helper"
require_relative '../../../lib/whatsapp_sdk/resource/interactive'
require_relative '../../../lib/whatsapp_sdk/resource/interactive_action'
require_relative '../../../lib/whatsapp_sdk/resource/interactive_action_button'
require_relative '../../../lib/whatsapp_sdk/resource/interactive_body'
require_relative '../../../lib/whatsapp_sdk/resource/interactive_footer'
require_relative '../../../lib/whatsapp_sdk/resource/interactive_header'

module WhatsappSdk
  module Resource
    module Resource
      class InteractiveTest < Minitest::Test
        def test_validation
          error = assert_raises(WhatsappSdk::Resource::Interactive::InvalidActionButtonsCount) do
            interactive_body = WhatsappSdk::Resource::InteractiveBody.new(text: "This is the body!")
            interactive_action = WhatsappSdk::Resource::InteractiveAction.new()
            interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionButton.new(
              type: WhatsappSdk::Resource::InteractiveActionButton::Type::Reply,
              title: "I am the button 1",
              id: "button_1",
            )
            interactive_reply_button_2 = WhatsappSdk::Resource::InteractiveActionButton.new(
              type: WhatsappSdk::Resource::InteractiveActionButton::Type::Reply,
              title: "I am the button 2",
              id: "button_2",
            )
            interactive_reply_button_3 = WhatsappSdk::Resource::InteractiveActionButton.new(
              type: WhatsappSdk::Resource::InteractiveActionButton::Type::Reply,
              title: "I am the button 3",
              id: "button_3",
            )
            interactive_reply_button_4 = WhatsappSdk::Resource::InteractiveActionButton.new(
              type: WhatsappSdk::Resource::InteractiveActionButton::Type::Reply,
              title: "I am the button 4",
              id: "button_4",
            )
            interactive_action.add_button(interactive_reply_button_1)
            interactive_action.add_button(interactive_reply_button_2)
            interactive_action.add_button(interactive_reply_button_3)
            interactive_action.add_button(interactive_reply_button_4)

            WhatsappSdk::Resource::Interactive.new(
              type: WhatsappSdk::Resource::Interactive::Type::ReplyButton,
              body: interactive_body,
              action: interactive_action,
            )
          end
          assert_equal("invalid length 4 for buttons in action. It should be 1, 2 or 3.", error.message)

          error = assert_raises(WhatsappSdk::Resource::Interactive::InvalidActionButtonsId) do
            interactive_body = WhatsappSdk::Resource::InteractiveBody.new(text: "This is the body!")
            interactive_action = WhatsappSdk::Resource::InteractiveAction.new()
            interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionButton.new(
              type: WhatsappSdk::Resource::InteractiveActionButton::Type::Reply,
              title: "I am the button 1",
              id: "button_1",
            )
            interactive_reply_button_2 = WhatsappSdk::Resource::InteractiveActionButton.new(
              type: WhatsappSdk::Resource::InteractiveActionButton::Type::Reply,
              title: "I am the button 2",
              id: "button_1",
            )
            interactive_action.add_button(interactive_reply_button_1)
            interactive_action.add_button(interactive_reply_button_2)

            WhatsappSdk::Resource::Interactive.new(
              type: WhatsappSdk::Resource::Interactive::Type::ReplyButton,
              body: interactive_body,
              action: interactive_action,
            )
          end
          assert_equal("duplicate ids [\"button_1\", \"button_1\"] for buttons in action. They should be unique.", error.message)
        end

        def test_to_json
          interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(
            type: WhatsappSdk::Resource::InteractiveHeader::Type::Text,
            text: "I am the header!",
          )

          interactive_body = WhatsappSdk::Resource::InteractiveBody.new(
            text: "I am the body!",
          )

          interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(
            text: "I am the footer!",
          )

          interactive_action = WhatsappSdk::Resource::InteractiveAction.new()

          interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionButton.new(
            type: WhatsappSdk::Resource::InteractiveActionButton::Type::Reply,
            title: "I am the button 1",
            id: "button_1",
          )
          interactive_action.add_button(interactive_reply_button_1)

          interactive_reply_button_2 = WhatsappSdk::Resource::InteractiveActionButton.new(
            type: WhatsappSdk::Resource::InteractiveActionButton::Type::Reply,
            title: "I am the button 2",
            id: "button_2",
          )
          interactive_action.add_button(interactive_reply_button_2)

          interactive_reply_buttons = WhatsappSdk::Resource::Interactive.new(
            type: WhatsappSdk::Resource::Interactive::Type::ReplyButton,
            header: interactive_header,
            body: interactive_body,
            footer: interactive_footer,
            action: interactive_action,
          )

          assert_equal(
            {
              type: "button",
              header: {
                type: "text",
                text: "I am the header!",
              },
              body: {
                text: "I am the body!",
              },
              footer: {
                text: "I am the footer!",
              },
              action: {
                buttons: [
                  {
                    type: "reply",
                    reply: {
                      title: "I am the button 1",
                      id: "button_1",
                    },
                  },
                  {
                    type: "reply",
                    reply: {
                      title: "I am the button 2",
                      id: "button_2",
                    },
                  },
                ],
              }
            },
            interactive_reply_buttons.to_json
          )
        end
      end
    end
  end
end