# frozen_string_literal: true
# typed: true

require "test_helper"
require_relative '../../../lib/whatsapp_sdk/resource/parameter_object'
require_relative '../../../lib/whatsapp_sdk/resource/media'
require_relative '../../../lib/whatsapp_sdk/resource/date_time'
require_relative '../../../lib/whatsapp_sdk/resource/currency'
require_relative '../../../lib/whatsapp_sdk/resource/component'

module WhatsappSdk
  module Resource
    module Resource
      class ComponentTest < Minitest::Test
        def test_button_index_is_set_to_0_by_default
          button_component = WhatsappSdk::Resource::Component.new(
            type: WhatsappSdk::Resource::Component::Type::BUTTON,
            sub_type: WhatsappSdk::Resource::Component::Subtype::QUICK_REPLY
          )

          assert_equal(0, button_component.index)
        end

        def test_validation
          error = assert_raises(WhatsappSdk::Resource::Component::InvalidField) do
            WhatsappSdk::Resource::Component.new(
              type: WhatsappSdk::Resource::Component::Type::HEADER,
              sub_type: WhatsappSdk::Resource::Component::Subtype::QUICK_REPLY
            )
          end
          assert_equal("sub_type is not required when type is not button", error.message)
          assert_equal(:sub_type, error.field)

          error = assert_raises(WhatsappSdk::Resource::Component::InvalidField) do
            WhatsappSdk::Resource::Component.new(
              type: WhatsappSdk::Resource::Component::Type::HEADER, index: 0
            )
          end
          assert_equal("index is not required when type is not button", error.message)
          assert_equal(:index, error.field)
        end

        def test_add_parameters
          image = WhatsappSdk::Resource::Media.new(type: "image", link: "http(s)://URL", caption: "caption")
          document = WhatsappSdk::Resource::Media.new(type: "document", link: "http(s)://URL", filename: "txt.rb")
          video = WhatsappSdk::Resource::Media.new(type: "video", id: 123)
          currency = WhatsappSdk::Resource::Currency.new(code: "USD", amount: 1000, fallback_value: "1000")
          date_time = WhatsappSdk::Resource::DateTime.new(fallback_value: "2020-01-01T00:00:00Z")

          parameter_text = WhatsappSdk::Resource::ParameterObject.new(type: "text", text: "I am a text")
          parameter_currency = WhatsappSdk::Resource::ParameterObject.new(type: "currency", currency: currency)
          parameter_date_time = WhatsappSdk::Resource::ParameterObject.new(type: "date_time", date_time: date_time)
          parameter_image = WhatsappSdk::Resource::ParameterObject.new(type: "image", image: image)
          parameter_document = WhatsappSdk::Resource::ParameterObject.new(type: "document", document: document)
          parameter_video = WhatsappSdk::Resource::ParameterObject.new(type: "video", video: video)

          header_component = WhatsappSdk::Resource::Component.new(type: WhatsappSdk::Resource::Component::Type::HEADER)

          header_component.add_parameter(parameter_text)
          header_component.add_parameter(parameter_currency)
          header_component.add_parameter(date_time)
          header_component.add_parameter(parameter_image)
          header_component.add_parameter(parameter_document)
          header_component.add_parameter(parameter_video)
          header_component.add_parameter(parameter_date_time)

          assert_equal(
            [
              parameter_text, parameter_currency, date_time, parameter_image,
              parameter_document, parameter_video, parameter_date_time
            ],
            header_component.parameters
          )
        end

        def test_to_json_header_component
          image = WhatsappSdk::Resource::Media.new(type: "image", link: "http(s)://URL", caption: "caption")
          parameter_image = WhatsappSdk::Resource::ParameterObject.new(type: "image", image: image)

          header_component = WhatsappSdk::Resource::Component.new(
            type: WhatsappSdk::Resource::Component::Type::HEADER,
            parameters: [parameter_image]
          )

          assert_equal(
            {
              type: "header",
              parameters: [
                {
                  type: "image",
                  image: {
                    link: "http(s)://URL",
                    caption: "caption"
                  }
                }
              ]
            },
            header_component.to_json
          )
        end

        def test_to_json_body_component
          parameter_text = WhatsappSdk::Resource::ParameterObject.new(type: "text", text: "I am a text")

          currency = WhatsappSdk::Resource::Currency.new(code: "USD", amount: 1000, fallback_value: "1000")
          parameter_currency = WhatsappSdk::Resource::ParameterObject.new(type: "currency", currency: currency)

          date_time = WhatsappSdk::Resource::DateTime.new(fallback_value: "2020-01-01T00:00:00Z")
          parameter_date_time = WhatsappSdk::Resource::ParameterObject.new(type: "date_time", date_time: date_time)

          body_component = WhatsappSdk::Resource::Component.new(
            type: WhatsappSdk::Resource::Component::Type::BODY,
            parameters: [parameter_text, parameter_currency, parameter_date_time]
          )

          assert_equal(
            {
              type: "body",
              parameters: [
                {
                  type: "text",
                  text: "I am a text"
                },
                {
                  type: "currency",
                  currency: {
                    fallback_value: "1000",
                    code: "USD",
                    amount_1000: 1000
                  }
                },
                {
                  type: "date_time",
                  date_time: {
                    fallback_value: "2020-01-01T00:00:00Z"
                  }
                }
              ]
            },
            body_component.to_json
          )
        end

        def test_to_json_button_component
          button_component = WhatsappSdk::Resource::Component.new(
            type: WhatsappSdk::Resource::Component::Type::BUTTON,
            index: 0,
            sub_type: WhatsappSdk::Resource::Component::Subtype::QUICK_REPLY,
            parameters: [
              WhatsappSdk::Resource::ButtonParameter.new(type: "payload", payload: "payload"),
              WhatsappSdk::Resource::ButtonParameter.new(type: "text", text: "text")
            ]
          )

          assert_equal(
            { type: "button", parameters: [{ type: "payload", payload: "payload" }, { type: "text", text: "text" }],
              sub_type: "quick_reply", index: 0 },
            button_component.to_json
          )
        end
      end
    end
  end
end
