# typed: true
# frozen_string_literal: true

require "test_helper"
require 'api/responses/read_message_data_response'
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
        client = Client.new("test_token")
        @messages_api = Messages.new(client)
      end

      def test_send_text_handles_error_response
        mocked_error_response = mock_error_response(api: @messages_api)
        response = @messages_api.send_text(
          sender_id: 123_123, recipient_number: 56_789, message: "hola"
        )

        assert_mock_error_response(mocked_error_response, response, Responses::MessageErrorResponse)
      end

      def test_send_text_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_text(
          sender_id: 123_123, recipient_number: 56_789, message: "hola"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_text_message_with_valid_params
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "text",
            text: { body: "hola" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_text(
          sender_id: 123_123, recipient_number: 56_789, message: "hola"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_message_accept_message_id_to_reply_a_message
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "text",
            text: { body: "hola" },
            context: { message_id: "wamid.987654321" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_text(
          sender_id: 123_123, recipient_number: 56_789, message: "hola", message_id: "wamid.987654321"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_location_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_location(
          sender_id: 123_123, recipient_number: 56_789,
          longitude: 45.4215, latitude: 75.6972, name: "nacho", address: "141 cooper street"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_location_message_with_valid_params
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
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_location(
          sender_id: 123_123, recipient_number: 56_789,
          longitude: longitude, latitude: latitude, name: name, address: address
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
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
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_image(
          sender_id: 123_123, recipient_number: 56_789,
          image_id: "123", link: nil, caption: ""
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_image_message_with_a_link
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "image",
            image: { link: image_link, caption: "Ignacio Chiazzo Profile" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_image(
          sender_id: 123_123, recipient_number: 56_789,
          link: image_link, caption: "Ignacio Chiazzo Profile"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_image_message_with_an_image_id
        image_id = "12_345"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "image",
            image: { id: image_id, caption: "Ignacio Chiazzo Profile" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_image(
          sender_id: 123_123, recipient_number: 56_789,
          image_id: image_id, caption: "Ignacio Chiazzo Profile"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_audio_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_audio(
          sender_id: 123_123, recipient_number: 56_789, link: "1234"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_audio_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages_api.send_audio(
            sender_id: 123_123, recipient_number: 56_789, link: nil, audio_id: nil
          )
        end
      end

      def test_send_audio_message_with_a_link
        audio_link = "1234"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "audio",
            audio: { link: audio_link }
          },
          multipart: true,
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_audio(
          sender_id: 123_123, recipient_number: 56_789, link: audio_link
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_audio_message_with_an_audio_id
        audio_id = "12_345"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "audio",
            audio: { id: audio_id }
          },
          multipart: true,
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_audio(
          sender_id: 123_123, recipient_number: 56_789, audio_id: audio_id
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_video_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages_api.send_video(
            sender_id: 123_123, recipient_number: 56_789, link: nil, video_id: nil
          )
        end
      end

      def test_send_video_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_video(
          sender_id: 123_123, recipient_number: 56_789,
          video_id: "123", link: nil, caption: ""
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_video_message_with_a_link
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "video",
            video: { link: video_link, caption: "Ignacio Chiazzo Profile" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_video(
          sender_id: 123_123, recipient_number: 56_789,
          link: video_link, caption: "Ignacio Chiazzo Profile"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_video_message_with_an_video_id
        video_id = "12_345"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "video",
            video: { id: video_id, caption: "Ignacio Chiazzo Profile" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_video(
          sender_id: 123_123, recipient_number: 56_789,
          video_id: video_id, caption: "Ignacio Chiazzo Profile"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_document_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages_api.send_document(
            sender_id: 123_123, recipient_number: 56_789, link: nil, document_id: nil
          )
        end
      end

      def test_send_document_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_document(
          sender_id: 123_123, recipient_number: 56_789,
          document_id: "123", link: nil, caption: ""
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_document_message_with_a_link
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "document",
            document: { link: document_link, caption: "Ignacio Chiazzo Profile" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_document(
          sender_id: 123_123, recipient_number: 56_789,
          link: document_link, caption: "Ignacio Chiazzo Profile"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_document_message_with_file_name
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "document",
            document: { link: document_link, caption: "Ignacio Chiazzo Profile", filename: "custom_name" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_document(
          sender_id: 123_123, recipient_number: 56_789,
          link: document_link, caption: "Ignacio Chiazzo Profile", filename: "custom_name"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_document_message_with_a_document_id
        document_id = "12_345"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "document",
            document: { id: document_id, caption: "Ignacio Chiazzo Profile" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_document(
          sender_id: 123_123, recipient_number: 56_789,
          document_id: document_id, caption: "Ignacio Chiazzo Profile"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_sticker_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Resource::Errors::MissingArgumentError) do
          @messages_api.send_sticker(
            sender_id: 123_123, recipient_number: 56_789, link: nil, sticker_id: nil
          )
        end
      end

      def test_send_sticker_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_sticker(
          sender_id: 123_123, recipient_number: 56_789,
          sticker_id: "123", link: nil
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_sticker_message_with_a_link
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: Resource::Media::Type::Sticker,
            sticker: { link: sticker_link }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_sticker(
          sender_id: 123_123, recipient_number: 56_789, link: sticker_link
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_sticker_message_with_an_sticker_id
        sticker_id = "12_345"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: Resource::Media::Type::Sticker,
            sticker: { id: sticker_id }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_sticker(
          sender_id: 123_123, recipient_number: 56_789, sticker_id: sticker_id
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_contacts_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_contacts(
          sender_id: 123_123, recipient_number: 56_789, contacts: [create_contact]
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_contacts_with_a_valid_response
        contacts = [create_contact]
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "contacts",
            contacts: contacts.map(&:to_h)
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_contacts(
          sender_id: 123_123, recipient_number: 56_789, contacts: contacts
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_read_message_with_a_valid_response
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            status: "read",
            message_id: "12345"
          },
          headers: { "Content-Type" => "application/json" }
        ).returns({ "success" => true })

        message_response = @messages_api.read_message(
          sender_id: 123_123, message_id: "12345"
        )

        assert_instance_of(Response, message_response)
        assert_nil(message_response.error)
        assert_predicate(message_response, :ok?)
        assert_instance_of(Responses::ReadMessageDataResponse, message_response.data)
        assert_predicate(message_response.data, :success?)
      end

      def test_read_message_with_an_invalid_response
        mocked_error_response = mock_error_response(api: @messages_api)
        response = @messages_api.read_message(
          sender_id: 123_123, message_id: "12345"
        )

        assert_mock_error_response(mocked_error_response, response, Responses::MessageErrorResponse)
        assert_predicate(response, :error?)
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
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_template(
          sender_id: 12_345, recipient_number: 12_345_678, name: "hello_world", language: "en_US",
          components_json: [{
            type: "header",
            parameters: [
              {
                type: "image",
                image: {
                  link: "http(s)://URL"
                }
              }
            ]
          }]
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_template_with_success_response_by_passing_components
        currency = Resource::Currency.new(code: "USD", amount: 1000, fallback_value: "1000")
        date_time = Resource::DateTime.new(fallback_value: "2020-01-01T00:00:00Z")
        image = Resource::Media.new(type: Resource::Media::Type::Image, link: "http(s)://URL")
        location = Resource::Location.new(latitude: 25.779510, longitude: -80.338631, name: "miami store",
                                          address: "820 nw 87th ave, miami, fl")

        parameter_image = Resource::ParameterObject.new(
          type: Resource::ParameterObject::Type::Image, image: image
        )
        parameter_text = Resource::ParameterObject.new(
          type: Resource::ParameterObject::Type::Text, text: "TEXT_STRING"
        )
        parameter_currency = Resource::ParameterObject.new(
          type: Resource::ParameterObject::Type::Currency, currency: currency
        )
        parameter_date_time = Resource::ParameterObject.new(
          type: Resource::ParameterObject::Type::DateTime, date_time: date_time
        )
        parameter_location = Resource::ParameterObject.new(
          type: Resource::ParameterObject::Type::Location,
          location: location
        )

        header_component = Resource::Component.new(
          type: Resource::Component::Type::Header,
          parameters: [parameter_image]
        )

        body_component = Resource::Component.new(
          type: Resource::Component::Type::Body,
          parameters: [parameter_text, parameter_currency, parameter_date_time]
        )

        button_component1 = Resource::Component.new(
          type: Resource::Component::Type::Button,
          index: 0,
          sub_type: Resource::Component::Subtype::QuickReply,
          parameters: [
            Resource::ButtonParameter.new(type: Resource::ButtonParameter::Type::Payload,
                                          payload: "PAYLOAD")
          ]
        )

        button_component2 = Resource::Component.new(
          type: Resource::Component::Type::Button,
          index: 1,
          sub_type: Resource::Component::Subtype::QuickReply,
          parameters: [
            Resource::ButtonParameter.new(type: Resource::ButtonParameter::Type::Payload,
                                          payload: "PAYLOAD")
          ]
        )

        location_component = Resource::Component.new(
          type: Resource::Component::Type::Header,
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
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_template(
          sender_id: 123_123, recipient_number: 12_345_678, name: "hello_world", language: "en_US",
          components: [header_component, body_component, button_component1, button_component2, location_component]
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_reaction_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_reaction(
          sender_id: 123_123, recipient_number: 56_789, message_id: "12345", emoji: "\\uD83D\\uDE00"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_reaction_with_a_valid_response
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "reaction",
            reaction: {
              message_id: "12345",
              emoji: "\\uD83D\\uDE00"
            }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_reaction(
          sender_id: 123_123, recipient_number: 56_789, message_id: "12345", emoji: "\\uD83D\\uDE00"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_interactive_reply_buttons_with_success_response_by_passing_interactive_json
        mock_response(valid_contacts, valid_messages)

        message_response = @messages_api.send_interactive_reply_buttons(
          sender_id: 123_123, recipient_number: 12_345_678,
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

        assert_mock_response(valid_contacts, valid_messages, message_response)
      end

      def test_send_interactive_reply_buttons_with_success_response_by_passing_interactive
        interactive_header = Resource::InteractiveHeader.new(
          type: Resource::InteractiveHeader::Type::Text,
          text: "I am the header!"
        )

        interactive_body = Resource::InteractiveBody.new(
          text: "I am the body!"
        )

        interactive_footer = Resource::InteractiveFooter.new(
          text: "I am the footer!"
        )

        interactive_action = Resource::InteractiveAction.new(
          type: Resource::InteractiveAction::Type::ReplyButton
        )

        interactive_reply_button_1 = Resource::InteractiveActionReplyButton.new(
          title: "I am the button 1",
          id: "button_1"
        )
        interactive_action.add_reply_button(interactive_reply_button_1)

        interactive_reply_button_2 = Resource::InteractiveActionReplyButton.new(
          title: "I am the button 2",
          id: "button_2"
        )
        interactive_action.add_reply_button(interactive_reply_button_2)

        interactive_reply_buttons = Resource::Interactive.new(
          type: Resource::Interactive::Type::ReplyButton,
          header: interactive_header,
          body: interactive_body,
          footer: interactive_footer,
          action: interactive_action
        )

        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 12_345_678,
            recipient_type: "individual",
            type: "interactive",
            interactive: {
              type: "button",
              header: { type: "text", text: "I am the header!" },
              body: { text: "I am the body!" },
              footer: { text: "I am the footer!" },
              action: {
                buttons: [
                  {
                    type: "reply",
                    reply: { title: "I am the button 1", id: "button_1" }
                  },
                  {
                    type: "reply",
                    reply: { title: "I am the button 2", id: "button_2" }
                  }
                ]
              }
            }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_interactive_reply_buttons(
          sender_id: 123_123, recipient_number: 12_345_678,
          interactive: interactive_reply_buttons
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_interactive_list_messages_with_success_response_by_passing_interactive_json
        mock_response(valid_contacts, valid_messages)

        message_response = @messages_api.send_interactive_list_messages(
          sender_id: 123_123, recipient_number: 12_345_678,
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

        assert_mock_response(valid_contacts, valid_messages, message_response)
      end

      def test_send_interactive_list_messages_with_success_response_by_passing_interactive
        interactive_header = Resource::InteractiveHeader.new(
          type: Resource::InteractiveHeader::Type::Text,
          text: "I am the header!"
        )

        interactive_body = Resource::InteractiveBody.new(
          text: "I am the body!"
        )

        interactive_footer = Resource::InteractiveFooter.new(
          text: "I am the footer!"
        )

        interactive_action = Resource::InteractiveAction.new(
          type: Resource::InteractiveAction::Type::ListMessage
        )

        interactive_action.button = "I am the button CTA"

        interactive_section_1 = Resource::InteractiveActionSection.new(
          title: "I am the section 1"
        )
        interactive_section_1_row_1 = Resource::InteractiveActionSectionRow.new(
          title: "I am the row 1 title",
          id: "section_1_row_1",
          description: "I am the optional section 1 row 1 description"
        )
        interactive_section_1.add_row(interactive_section_1_row_1)
        interactive_action.add_section(interactive_section_1)

        interactive_list_messages = Resource::Interactive.new(
          type: Resource::Interactive::Type::ListMessage,
          header: interactive_header,
          body: interactive_body,
          footer: interactive_footer,
          action: interactive_action
        )

        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: 12_345_678,
            recipient_type: "individual",
            type: "interactive",
            interactive: {
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
            }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_interactive_list_messages(
          sender_id: 123_123, recipient_number: 12_345_678,
          interactive: interactive_list_messages
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      private

      def sticker_link
        "sticker_link"
      end

      def document_link
        "https://medium.com/"
      end

      def video_link
        "https://www.youtube.com/12345"
      end

      def image_link
        @image_link ||= "https://ignaciochiazzo.com/static/4c403819b9750c8ad8b20a75308f2a8a/876d5/profile-pic.avif"
      end

      def valid_contacts
        @valid_contacts ||= [{ "input" => "1234", "wa_id" => "1234" }]
      end

      def valid_messages
        @valid_messages ||= [{ "id" => "9876" }]
      end

      def mock_response(contacts, messages)
        @messages_api.stubs(:send_request).returns(valid_response(contacts, messages))
        valid_response(contacts, messages)
      end

      def valid_response(contacts, messages)
        @valid_response ||= { "messaging_product" => "whatsapp", "contacts" => contacts, "messages" => messages }
      end

      def assert_mock_response(_expected_contacts, _expected_messages, message_response)
        assert_instance_of(Response, message_response)
        assert_nil(message_response.error)
        assert_predicate(message_response, :ok?)
        assert_equal(1, message_response.data.contacts.size)
        assert_contacts([{ "input" => "1234", "wa_id" => "1234" }], message_response.data.contacts)

        assert_equal(1, message_response.data.messages.size)
        assert_messages([{ "id" => "9876" }], message_response.data.messages)
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
