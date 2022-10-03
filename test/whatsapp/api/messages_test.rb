# frozen_string_literal: true
# typed: true

require "test_helper"
require_relative '../../../lib/whatsapp_sdk/api/responses/read_message_data_response'
require_relative '../../../lib/whatsapp_sdk/api/messages'
require_relative '../../../lib/whatsapp_sdk/resource/address_type'
require_relative '../../../lib/whatsapp_sdk/resource/address'
require_relative '../../../lib/whatsapp_sdk/resource/contact'
require_relative '../../../lib/whatsapp_sdk/resource/phone_number'
require_relative '../../../lib/whatsapp_sdk/resource/url'
require_relative '../../../lib/whatsapp_sdk/resource/email'
require_relative '../../../lib/whatsapp_sdk/resource/org'
require_relative '../../../lib/whatsapp_sdk/resource/name'
require_relative '../../../lib/whatsapp_sdk/api/client'
require_relative '../contact_helper'

module WhatsappSdk
  module Api
    class MessagesTest < Minitest::Test
      include ContactHelper

      def setup
        client = WhatsappSdk::Api::Client.new("test_token")
        @messages_api = WhatsappSdk::Api::Messages.new(client)
      end

      def test_send_text_handles_error_response
        mocked_error_response = mock_error_response
        response = @messages_api.send_text(
          sender_id: 123_123, recipient_number: 56_789, message: "hola"
        )
        assert_mock_error_response(mocked_error_response, response)
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
        assert_raises(WhatsappSdk::Api::Messages::MissingArgumentError) do
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
        assert_raises(WhatsappSdk::Api::Messages::MissingArgumentError) do
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
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_audio(
          sender_id: 123_123, recipient_number: 56_789, audio_id: audio_id
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_video_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(WhatsappSdk::Api::Messages::MissingArgumentError) do
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
        assert_raises(WhatsappSdk::Api::Messages::MissingArgumentError) do
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

      def test_send_document_message_with_an_document_id
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
        assert_raises(WhatsappSdk::Api::Messages::MissingArgumentError) do
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

        assert_equal(WhatsappSdk::Api::Response, message_response.class)
        assert_nil(message_response.error)
        assert_predicate(message_response, :ok?)
        assert_equal(WhatsappSdk::Api::Responses::ReadMessageDataResponse, message_response.data.class)
        assert_predicate(message_response.data, :success?)
      end

      def test_read_message_with_an_invalid_response
        mocked_error_response = mock_error_response
        response = @messages_api.read_message(
          sender_id: 123_123, message_id: "12345"
        )
        assert_mock_error_response(mocked_error_response, response)
        assert_predicate(response, :error?)
      end

      def test_send_template_raises_an_error_when_component_and_component_json_are_not_provided
        error = assert_raises(WhatsappSdk::Api::Messages::MissingArgumentError) do
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

      # rubocop:disable Metrics/MethodLength
      def test_send_template_with_success_response_by_passing_components
        currency = WhatsappSdk::Resource::Currency.new(code: "USD", amount: 1000, fallback_value: "1000")
        date_time = WhatsappSdk::Resource::DateTime.new(fallback_value: "2020-01-01T00:00:00Z")
        image = WhatsappSdk::Resource::Media.new(type: WhatsappSdk::Resource::Media::Type::Image, link: "http(s)://URL")

        parameter_image = WhatsappSdk::Resource::ParameterObject.new(
          type: WhatsappSdk::Resource::ParameterObject::Type::Image, image: image
        )
        parameter_text = WhatsappSdk::Resource::ParameterObject.new(
          type: WhatsappSdk::Resource::ParameterObject::Type::Text, text: "TEXT_STRING"
        )
        parameter_currency = WhatsappSdk::Resource::ParameterObject.new(
          type: WhatsappSdk::Resource::ParameterObject::Type::Currency, currency: currency
        )
        parameter_date_time = WhatsappSdk::Resource::ParameterObject.new(
          type: WhatsappSdk::Resource::ParameterObject::Type::DateTime, date_time: date_time
        )

        header_component = WhatsappSdk::Resource::Component.new(
          type: WhatsappSdk::Resource::Component::Type::Header,
          parameters: [parameter_image]
        )

        body_component = WhatsappSdk::Resource::Component.new(
          type: WhatsappSdk::Resource::Component::Type::Body,
          parameters: [parameter_text, parameter_currency, parameter_date_time]
        )

        button_component1 = WhatsappSdk::Resource::Component.new(
          type: WhatsappSdk::Resource::Component::Type::Button,
          index: 0,
          sub_type: WhatsappSdk::Resource::Component::Subtype::QuickReply,
          parameters: [
            WhatsappSdk::Resource::ButtonParameter.new(type: WhatsappSdk::Resource::ButtonParameter::Type::Payload,
                                                       payload: "PAYLOAD")
          ]
        )

        button_component2 = WhatsappSdk::Resource::Component.new(
          type: WhatsappSdk::Resource::Component::Type::Button,
          index: 1,
          sub_type: WhatsappSdk::Resource::Component::Subtype::QuickReply,
          parameters: [
            WhatsappSdk::Resource::ButtonParameter.new(type: WhatsappSdk::Resource::ButtonParameter::Type::Payload,
                                                       payload: "PAYLOAD")
          ]
        )

        @messages_api.expects(:send_request).with({
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
                                                          }
                                                        ]
                                                      }
                                                    },
                                                    headers: { "Content-Type" => "application/json" }
                                                  }).returns(valid_response(valid_contacts, valid_messages))

        message_response = @messages_api.send_template(
          sender_id: 123_123, recipient_number: 12_345_678, name: "hello_world", language: "en_US",
          components: [header_component, body_component, button_component1, button_component2]
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end
      # rubocop:enable Metrics/MethodLength

      private

      def mock_error_response
        error_response = {
          "error" => {
            "message" => "Unsupported post request.",
            "type" => "GraphMethodException",
            "code" => 100,
            "error_subcode" => 33,
            "fbtrace_id" => "Au93W6oW_Np0PyF7v5YwAiU"
          }
        }
        @messages_api.stubs(:send_request).returns(error_response)
        error_response
      end

      def assert_mock_error_response(mocked_error, response)
        refute_predicate(response, :ok?)
        assert_nil(response.data)
        error = response.error
        assert_equal(WhatsappSdk::Api::Responses::MessageErrorResponse, error.class)
        assert_equal(mocked_error["error"]["code"], error.code)
        assert_equal(mocked_error["error"]["error_subcode"], error.subcode)
        assert_equal(mocked_error["error"]["message"], error.message)
        assert_equal(mocked_error["error"]["error_subcode"], error.subcode)
        assert_equal(mocked_error["error"]["fbtrace_id"], error.fbtrace_id)
      end

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
        assert_equal(WhatsappSdk::Api::Response, message_response.class)
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
