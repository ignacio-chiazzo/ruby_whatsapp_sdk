# typed: true
# frozen_string_literal: true

require "test_helper"
require 'resource/parameter_object'
require 'resource/media'
require 'resource/date_time'
require 'resource/currency'
require 'resource/component'

module WhatsappSdk
  module Resource
    module Resource
      class ComponentTest < Minitest::Test
        def test_button_index_is_set_to_0_by_default
          button_component = Component.new(type: Component::Type::Button, sub_type: Component::Subtype::QuickReply)
          assert_equal(0, button_component.index)
        end

        def test_validation
          error = assert_raises(Component::InvalidField) do
            Component.new(type: Component::Type::Header, sub_type: Component::Subtype::QuickReply)
          end
          assert_equal("sub_type is not required when type is not button", error.message)
          assert_equal(:sub_type, error.field)

          error = assert_raises(Component::InvalidField) do
            Component.new(type: Component::Type::Header, index: 0)
          end
          assert_equal("index is not required when type is not button", error.message)
          assert_equal(:index, error.field)
        end

        def test_add_parameters
          image = Media.new(type: Media::Type::Image,
                            link: "http(s)://URL", caption: "caption")
          document = Media.new(type: Media::Type::Document,
                               link: "http(s)://URL", filename: "txt.rb")
          video = Media.new(type: Media::Type::Video, id: "123")
          currency = Currency.new(code: "USD", amount: 1000, fallback_value: "1000")
          date_time = DateTime.new(fallback_value: "2020-01-01T00:00:00Z")

          parameter_text = ParameterObject.new(type: ParameterObject::Type::Text, text: "I am a text")
          parameter_currency = ParameterObject.new(type: ParameterObject::Type::Currency, currency: currency)
          parameter_date_time = ParameterObject.new(type: ParameterObject::Type::DateTime, date_time: date_time)
          parameter_image = ParameterObject.new(type: ParameterObject::Type::Image, image: image)
          parameter_document = ParameterObject.new(type: ParameterObject::Type::Document, document: document)
          parameter_video = ParameterObject.new(type: ParameterObject::Type::Video, video: video)

          header_component = Component.new(type: Component::Type::Header)

          header_component.add_parameter(parameter_text)
          header_component.add_parameter(parameter_currency)
          header_component.add_parameter(parameter_date_time)
          header_component.add_parameter(parameter_image)
          header_component.add_parameter(parameter_document)
          header_component.add_parameter(parameter_video)
          header_component.add_parameter(parameter_date_time)

          assert_equal(
            [
              parameter_text, parameter_currency, parameter_date_time, parameter_image,
              parameter_document, parameter_video, parameter_date_time
            ],
            header_component.parameters
          )
        end

        def test_to_json_header_component
          image = Media.new(type: Media::Type::Image, link: "http(s)://URL", caption: "caption")
          parameter_image = ParameterObject.new(type: ParameterObject::Type::Image, image: image)

          header_component = Component.new(
            type: Component::Type::Header,
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
          parameter_text = ParameterObject.new(type: ParameterObject::Type::Text, text: "I am a text")

          currency = Currency.new(code: "USD", amount: 1000, fallback_value: "1000")
          parameter_currency = ParameterObject.new(type: ParameterObject::Type::Currency, currency: currency)

          date_time = DateTime.new(fallback_value: "2020-01-01T00:00:00Z")
          parameter_date_time = ParameterObject.new(type: ParameterObject::Type::DateTime, date_time: date_time)

          body_component = Component.new(
            type: Component::Type::Body,
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
          button_component = Component.new(
            type: Component::Type::Button,
            index: 0,
            sub_type: Component::Subtype::QuickReply,
            parameters: [
              ButtonParameter.new(type: ButtonParameter::Type::Payload, payload: "payload"),
              ButtonParameter.new(type: ButtonParameter::Type::Text, text: "text")
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
