# typed: true
# frozen_string_literal: true

require "test_helper"
require 'api/messages'
require 'resource/address_type'
require 'resource/address'
require 'resource/contact'
require 'resource/interactive'
require 'resource/interactive_action'
require 'resource/interactive_action_reply_button'
require 'resource/interactive_action_section'
require 'resource/interactive_action_section_row'
require 'resource/interactive_body'
require 'resource/interactive_footer'
require 'resource/interactive_header'
require 'resource/phone_number'
require 'resource/url'
require 'resource/email'
require 'resource/org'
require 'resource/name'
require 'api/client'
require_relative '../contact_helper'

module WhatsappSdk
  module Api
    class MessagesTest < Minitest::Test
      include(ContactHelper)
      include(ErrorsHelper)

      def setup
        client = Client.new(ENV.fetch("WHATSAPP_ACCESS_TOKEN", nil))
        @messages_api = Messages.new(client)
        @sender_id = 107_878_721_936_019
        @recipient_number = 13_437_772_910
      end

      def test_send_text_handles_error_response
        VCR.use_cassette("messages/send_text_handles_error_response") do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @messages_api.send_text(sender_id: 123_123, recipient_number: 56_789, message: "hola")
          end

          assert_unsupported_request_error_v2("post", "123123", "AzJYAMZdf4WaDlLDXeqjTr9", http_error.error_info)
        end
      end

      def test_send_text_message_with_success_response
        VCR.use_cassette("messages/send_text_message_with_success_response") do
          response = @messages_api.send_text(
            sender_id: @sender_id, recipient_number: @recipient_number, message: "hola"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBIyQzU4M0Q4MDc2NDY4ODgwNjUA" }]
                                  }, response)
        end
      end

      def test_send_message_accept_message_id_to_reply_a_message
        VCR.use_cassette("messages/send_message_accept_message_id_to_reply_a_message") do
          response = @messages_api.send_text(
            sender_id: @sender_id,
            recipient_number: @recipient_number,
            message: "gracias",
            message_id: "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBI3OEVCRjczQ0JGNzYzMTdBRDIA"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBI1NEJFQkEzNzg0QURCMUI5MkEA" }]
                                  }, response)
        end
      end

      def test_send_location_message_with_success_response
        VCR.use_cassette("messages/send_location_message_with_success_response") do
          response = @messages_api.send_location(
            sender_id: @sender_id, recipient_number: @recipient_number,
            longitude: 45.4215, latitude: 75.6972, name: "nacho", address: "141 cooper street"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBJBNzIyQjU0ODNGNkY2MUIzNDcA" }]
                                  }, response)
        end
      end

      def test_send_location_message_sends_the_correct_params
        longitude = 45.4215
        latitude = 75.6972
        name = "nacho"
        address = "141 cooper street"

        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "location",
            location: {
              longitude: longitude,
              latitude: latitude,
              name: name,
              address: address
            }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response)

        message_response = @messages_api.send_location(
          sender_id: 123_123, recipient_number: 56_789,
          longitude: longitude, latitude: latitude, name: name, address: address
        )

        assert_message_response({
                                  contacts: [{ "input" => "1234", "wa_id" => "1234" }],
                                  messages: [{ "id" => "9876" }]
                                }, message_response)
      end

      def test_send_image_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages_api.send_image(
            sender_id: 123_123, recipient_number: 56_789,
            image_id: nil, link: nil, caption: ""
          )
        end
      end

      def test_send_image_message_with_success_response
        VCR.use_cassette("messages/send_image_with_success_response") do
          response = @messages_api.send_image(
            sender_id: @sender_id, recipient_number: @recipient_number,
            image_id: "1761991787669262", link: nil, caption: ""
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBI3OTU0MDYzN0QyNzdCRDlENEYA" }]
                                  }, response)
        end
      end

      def test_send_image_message_with_a_link
        VCR.use_cassette("messages/send_image_message_with_a_link") do
          image_link = "https://ignaciochiazzo.com/static/4c403819b9750c8ad8b20a75308f2a8a/876d5/profile-pic.avif"
          response = @messages_api.send_image(
            sender_id: @sender_id, recipient_number: @recipient_number,
            link: image_link, caption: "Ignacio Chiazzo Profile"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBJFOTU0Mzg1NTBBQjI5NkE3OUMA" }]
                                  }, response)
        end
      end

      def test_send_image_message_with_an_image_id
        VCR.use_cassette("messages/send_image_message_with_an_image_id") do
          message_response = @messages_api.send_image(
            sender_id: @sender_id, recipient_number: @recipient_number,
            image_id: "1761991787669262", caption: "Ignacio Chiazzo Profile"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBIyM0NGQkQ5RDA3NkRDNjREODMA" }]
                                  }, message_response)
        end
      end

      def test_send_audio_message_with_success_response
        VCR.use_cassette("messages/send_audio_message_with_success_response") do
          message_response = @messages_api.send_audio(
            sender_id: @sender_id, recipient_number: @recipient_number, audio_id: "914268667232441"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBJDOEE3RTMxOEIzMzhCQTU4OTYA" }]
                                  }, message_response)
        end
      end

      def test_send_audio_raises_an_error_if_link_and_id_are_not_provided
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages_api.send_audio(
            sender_id: 123_123, recipient_number: 56_789, link: nil, audio_id: nil
          )
        end
      end

      def test_send_audio_message_with_a_link
        VCR.use_cassette("messages/send_audio_message_with_success_response") do
          link = "https://lookaside.fbsbx.com/whatsapp_business/attachments/?mid=914268667232441&" \
                 "ext=1728913145&hash=ATtV69tQN8OKiNmN_0SYR73eo3kshm76rQwUvIpfbVAHrA"
          message_response = @messages_api.send_audio(
            sender_id: @sender_id, recipient_number: @recipient_number, link: link
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBJDOEE3RTMxOEIzMzhCQTU4OTYA" }]
                                  }, message_response)
        end
      end

      def test_send_audio_message_with_an_audio_id
        VCR.use_cassette("messages/send_audio_message_with_success_response") do
          message_response = @messages_api.send_audio(
            sender_id: @sender_id, recipient_number: @recipient_number, audio_id: "914268667232441"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBJDOEE3RTMxOEIzMzhCQTU4OTYA" }]
                                  }, message_response)
        end
      end

      def test_send_video_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages_api.send_video(
            sender_id: 123_123, recipient_number: 56_789, link: nil, video_id: nil
          )
        end
      end

      def test_send_video_message_with_success_response
        VCR.use_cassette("messages/send_video_message_with_success_response") do
          message_response = @messages_api.send_video(
            sender_id: @sender_id, recipient_number: @recipient_number,
            video_id: "535689082735659", link: nil, caption: "here we have the caption"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBIxMTJCOUFEQTAyNjUxQTZBQ0QA" }]
                                  }, message_response)
        end
      end

      def test_send_video_message_with_a_link
        VCR.use_cassette("messages/send_video_message_with_a_link") do
          video_link = "https://lookaside.fbsbx.com/whatsapp_business/attachments/" \
                       "?mid=535689082735659&ext=1728914425&hash=ATsJzdzBhUZo3p6_XWI6MH2zzIyaatYIMQrySbaG-93Z3g"
          message_response = @messages_api.send_video(
            sender_id: @sender_id, recipient_number: @recipient_number,
            link: video_link, caption: "Juan Roman"
          )

          assert_message_response(
            {
              contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
              messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBJDREFFMzNDMzM2NkNBOEUzMzEA" }]
            },
            message_response
          )
        end
      end

      def test_send_document_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages_api.send_document(
            sender_id: 123_123, recipient_number: 56_789, link: nil, document_id: nil
          )
        end
      end

      def test_send_document_message_with_success_response
        VCR.use_cassette("messages/send_document_message_with_success_response") do
          message_response = @messages_api.send_document(
            sender_id: @sender_id, recipient_number: @recipient_number,
            document_id: "1753306975419607", link: nil, caption: "Caption."
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBJCNUMzMDcxMjgyMzVGQTYwOEIA" }]
                                  }, message_response)
        end
      end

      def test_send_document_message_with_a_link
        VCR.use_cassette("messages/send_document_message_with_a_link") do
          document_link = "https://lookaside.fbsbx.com/whatsapp_business/attachments/" \
                          "?mid=1753306975419607&ext=1728915089&hash=ATvwReL_PLDHz6DWxvpaf6bNc1FGIwvIBTvDdxlnyn_ZXw"

          message_response = @messages_api.send_document(
            sender_id: @sender_id, recipient_number: @recipient_number,
            link: document_link, caption: "Ignacio Chiazzo Profile", filename: "custom_name"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBJBRDRBQjI0RjYxQzBCQzY3NDgA" }]
                                  }, message_response)
        end
      end

      def test_send_document_message_with_file_name
        VCR.use_cassette("messages/send_document_message_with_file_name") do
          message_response = @messages_api.send_document(
            sender_id: @sender_id, recipient_number: @recipient_number,
            document_id: "1753306975419607", caption: "Ignacio Chiazzo Profile", filename: "custom_name"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBIyN0U4Q0FEN0Y1NzU0RkMxOTMA" }]
                                  }, message_response)
        end
      end

      def test_send_sticker_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages_api.send_sticker(
            sender_id: 123_123, recipient_number: 56_789, link: nil, sticker_id: nil
          )
        end
      end

      def test_send_sticker_message_with_success_response
        VCR.use_cassette("messages/send_sticker_message_with_success_response") do
          message_response = @messages_api.send_sticker(
            sender_id: @sender_id, recipient_number: @recipient_number,
            sticker_id: "503335829198997", link: nil
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBIwNUYzQzZGM0NEOTQ5MkM4NUQA" }]
                                  }, message_response)
        end
      end

      def test_send_sticker_message_with_a_link
        VCR.use_cassette("messages/send_sticker_message_with_a_link") do
          sticker_link = "https://lookaside.fbsbx.com/whatsapp_business/attachments/" \
                         "?mid=503335829198997&ext=1728915786&hash=ATtVD-s23cG7a-A68fi7ZOjufIMjge89SIvw9wv9cvjIOg"

          message_response = @messages_api.send_sticker(
            sender_id: @sender_id, recipient_number: @recipient_number,
            link: sticker_link
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBI4MzdCOUM2RUEyRUM5MzQxMDkA" }]
                                  }, message_response)
        end
      end

      def test_send_contacts_with_success_response
        VCR.use_cassette("messages/send_contacts_with_success_response") do
          message_response = @messages_api.send_contacts(
            sender_id: @sender_id, recipient_number: @recipient_number, contacts: [create_contact]
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBJDRDhCNTAwRkU0MTdCNkI3OUMA" }]
                                  }, message_response)
        end
      end

      def test_read_message_with_a_valid_response
        skip("TODO")
        VCR.use_cassette("messages/read_message_with_a_valid_response") do
          msg_id = "TODO"
          message_response = @messages_api.read_message(sender_id: @sender_id, message_id: msg_id)

          assert_instance_of(Response, message_response)
          assert_nil(message_response.error)
          assert_predicate(message_response, :ok?)
          assert_instance_of(Responses::ReadMessageDataResponse, message_response.data)
          assert_predicate(message_response.data, :success?)
        end
      end

      def test_read_message_with_an_invalid_response
        VCR.use_cassette("messages/read_message_with_an_invalid_response") do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @messages_api.read_message(sender_id: @sender_id, message_id: "12345")
          end

          assert_equal(400, http_error.http_status)
          assert_error_info(
            {
              code: 100,
              error_subcode: nil,
              type: "OAuthException",
              message: "(#100) Invalid parameter",
              fbtrace_id: "A3PJ2-1aODhbAGAh66zQkwf"
            },
            http_error.error_info
          )
        end
      end

      def test_send_reaction_with_success_response
        VCR.use_cassette("messages/send_reaction_with_success_response") do
          message_response = @messages_api.send_reaction(
            sender_id: @sender_id,
            recipient_number: @recipient_number,
            message_id: "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBI2REVCOTdDQkIyMTcyQUQ1MkUA",
            emoji: "\u{1f550}"
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBI5REM5RkFGRjYwN0YwRUFFQkMA" }]
                                  }, message_response)
        end
      end

      def test_send_template_raises_an_error_when_component_and_component_json_are_not_provided
        error = assert_raises(Resource::Errors::MissingArgumentError) do
          @messages_api.send_template(
            sender_id: 123_123, recipient_number: 56_789, name: "template", language: "en_US"
          )
        end

        assert_equal("components or components_json is required", error.message)
      end

      def test_send_template_with_success_response_by_passing_components_json
        VCR.use_cassette("messages/send_template_with_success_response_by_passing_components_json") do
          # The template sample_shipping_confirmation has the following components:
          #   [
          #     {"type"=>"BODY", "text"=>"Your package has been shipped. It will be delivered in {{1}} business days."},
          #     {"type"=>"FOOTER", "text"=>"This message is from an unverified business."}
          #   ]
          # The message needs the parameter {{1}} which is the time it will be delivered (in text).

          message_response = @messages_api.send_template(
            sender_id: @sender_id,
            recipient_number: @recipient_number,
            name: "sample_shipping_confirmation",
            language: "en_US",
            components_json: [{
              type: "body",
              parameters: [
                {
                  type: "TEXT",
                  text: "2 hours"
                }
              ]
            }]
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBI2REE3M0I0NEYzQjM1NkI2MDcA" }]
                                  }, message_response)
        end
      end

      def test_send_template_with_success_response_by_passing_components_sends_the_correct_params
        currency = Resource::Currency.new(code: "USD", amount: 1000, fallback_value: "1000")
        date_time = Resource::DateTime.new(fallback_value: "2020-01-01T00:00:00Z")
        image = Resource::MediaComponent.new(type: Resource::MediaComponent::Type::IMAGE, link: "http(s)://URL")
        location = Resource::Location.new(latitude: 25.779510, longitude: -80.338631, name: "miami store",
                                          address: "820 nw 87th ave, miami, fl")

        parameter_image = Resource::ParameterObject.new(
          type: Resource::ParameterObject::Type::IMAGE, image: image
        )
        parameter_text = Resource::ParameterObject.new(
          type: Resource::ParameterObject::Type::TEXT, text: "TEXT_STRING"
        )
        parameter_currency = Resource::ParameterObject.new(
          type: Resource::ParameterObject::Type::CURRENCY, currency: currency
        )
        parameter_date_time = Resource::ParameterObject.new(
          type: Resource::ParameterObject::Type::DATE_TIME, date_time: date_time
        )
        parameter_location = Resource::ParameterObject.new(
          type: Resource::ParameterObject::Type::LOCATION,
          location: location
        )

        header_component = Resource::Component.new(
          type: Resource::Component::Type::HEADER,
          parameters: [parameter_image]
        )

        body_component = Resource::Component.new(
          type: Resource::Component::Type::BODY,
          parameters: [parameter_text, parameter_currency, parameter_date_time]
        )

        button_component1 = Resource::Component.new(
          type: Resource::Component::Type::BUTTON,
          index: 0,
          sub_type: Resource::Component::Subtype::QUICK_REPLY,
          parameters: [
            Resource::ButtonParameter.new(
              type: Resource::ButtonParameter::Type::PAYLOAD,
              payload: "PAYLOAD"
            )
          ]
        )

        button_component2 = Resource::Component.new(
          type: Resource::Component::Type::BUTTON,
          index: 1,
          sub_type: Resource::Component::Subtype::QUICK_REPLY,
          parameters: [
            Resource::ButtonParameter.new(
              type: Resource::ButtonParameter::Type::PAYLOAD,
              payload: "PAYLOAD"
            )
          ]
        )

        location_component = Resource::Component.new(
          type: Resource::Component::Type::HEADER,
          parameters: [parameter_location]
        )

        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 12_345_678,
            recipient_type: "individual",
            type: "template",
            template: {
              name: "hello_world",
              language: { code: "en_US" },
              components: [
                {
                  type: "header",
                  parameters: [
                    {
                      type: "image",
                      image: {
                        link: "http(s)://URL"
                      }
                    }
                  ]
                },
                {
                  type: "body",
                  parameters: [
                    {
                      type: "text",
                      text: "TEXT_STRING"
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
                {
                  type: "button",
                  sub_type: "quick_reply",
                  index: 0,
                  parameters: [
                    {
                      type: "payload",
                      payload: "PAYLOAD"
                    }
                  ]
                },
                {
                  type: "button",
                  sub_type: "quick_reply",
                  index: 1,
                  parameters: [
                    {
                      type: "payload",
                      payload: "PAYLOAD"
                    }
                  ]
                },
                {
                  type: "header",
                  parameters: [
                    {
                      type: "location",
                      location: {
                        latitude: 25.779510,
                        longitude: -80.338631,
                        name: "miami store",
                        address: "820 nw 87th ave, miami, fl"
                      }
                    }
                  ]
                }
              ]
            }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response)

        message_response = @messages_api.send_template(
          sender_id: 123_123, recipient_number: 12_345_678, name: "hello_world", language: "en_US",
          components: [header_component, body_component, button_component1, button_component2, location_component]
        )

        assert_message_response({
                                  contacts: [{ "input" => "1234", "wa_id" => "1234" }],
                                  messages: [{ "id" => "9876" }]
                                }, message_response)
      end

      def test_send_interactive_reply_buttons_with_success_response_by_passing_interactive_json
        VCR.use_cassette("messages/send_interactive_reply_buttons_with_success_response_by_passing_interactive_json") do
          message_response = @messages_api.send_interactive_reply_buttons(
            sender_id: @sender_id, recipient_number: @recipient_number,
            interactive_json: {
              "type" => "button",
              "header" => {
                "type" => "text",
                "text" => "I am the header!"
              },
              "body" => {
                "text" => "I am the body!"
              },
              "footer" => {
                "text" => "I am the footer!"
              },
              "action" => {
                "buttons" => [{
                  "type" => "reply",
                  "reply" => {
                    title: "This is button 1!",
                    id: "button_1"
                  }
                }, {
                  "type" => "reply",
                  "reply" => {
                    title: "This is button 2!",
                    id: "button_2"
                  }
                }]
              }
            }
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBI4MUQwRUE5NEZGRjFDNzA0QTkA" }]
                                  }, message_response)
        end
      end

      def test_send_interactive_list_messages_with_success_response_by_passing_interactive_json
        VCR.use_cassette("messages/send_interactive_list_messages_with_success_response_by_passing_interactive_json") do
          message_response = @messages_api.send_interactive_list_messages(
            sender_id: @sender_id, recipient_number: @recipient_number,
            interactive_json: {
              "type" => "list",
              "header" => {
                "type" => "text",
                "text" => "I am the header!"
              },
              "body" => {
                "text" => "I am the body!"
              },
              "footer" => {
                "text" => "I am the footer!"
              },
              "action" => {
                "button" => "I am the button CTA",
                "sections" => [
                  {
                    "title" => "I am section 1",
                    "rows" => [
                      {
                        "id" => "section_1_row_1",
                        "title" => "I am row 1",
                        "description" => "I am the optional section 1 row 1 description"
                      }
                    ]
                  },
                  {
                    "title" => "I am section 2",
                    "rows" => [
                      {
                        "id" => "section_2_row_1",
                        "title" => "I am row 1",
                        "description" => "I am the optional section 2 row 1 description"
                      },
                      {
                        "id" => "section_2_row_2",
                        "title" => "I am row 2",
                        "description" => "I am the optional section 2 row 2 description"
                      }
                    ]
                  }
                ]
              }
            }
          )

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => "wamid.HBgLMTM0Mzc3NzI5MTAVAgARGBJDOTkyMDUzODY3RTE0OTA4ODkA" }]
                                  }, message_response)
        end
      end

      def test_send_typing_indicator_with_success_response
        skip("TODO")
        VCR.use_cassette("messages/send_typing_indicator_with_success_response") do
          msg_id = "wamid.HBgMNTU0MTk2MTI3MzAwFQIAEhgWM0VCMEQ3OTQ5OTNBODkwMzg1QTZDRgA="
          message_response = @messages_api.send_typing_indicator(sender_id: @sender_id, message_id: msg_id)

          assert_message_response({
                                    contacts: [{ "input" => "13437772910", "wa_id" => "13437772910" }],
                                    messages: [{ "id" => msg_id }]
                                  }, message_response)
        end
      end

      private

      def valid_response
        @valid_response ||= {
          "messaging_product" => "whatsapp",
          "contacts" => [{ "input" => "1234", "wa_id" => "1234" }],
          "messages" => [{ "id" => "9876" }]
        }
      end

      def assert_message_response(expected_message, response)
        assert_instance_of(Api::Responses::MessageDataResponse, response)

        assert_equal(1, response.contacts.size)
        assert_contacts(expected_message[:contacts], response.contacts)
        assert_messages(expected_message[:messages], response.messages)
      end

      def assert_messages(expected_messages, messages)
        assert_equal(expected_messages.size, messages.size)
        expected_messages.each_with_index do |expected_message, index|
          assert_equal(expected_message["id"], messages[index].id)
        end
      end

      def assert_contacts(expected_contacts, contacts)
        assert_equal(expected_contacts.size, contacts.size)
        expected_contacts.each_with_index do |expected_contact, index|
          assert_equal(expected_contact["input"], contacts[index].input)
          assert_equal(expected_contact["wa_id"], contacts[index].wa_id)
        end
      end
    end
  end
end
