# typed: true
# frozen_string_literal: true

require "test_helper"
require "whatsapp_sdk/api/conversational_s"

module WhatsappSdk
  module Api
    class ConversationalSTest < Minitest::Test
      def setup
        client = Client.new("test_token")
        @conversational_s_api = ConversationalS.new(client)
      end

      def test_send_conversational_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @conversational_s_api.send_conversational_message(
          sender_id: 123_123, recipient_number: 56_789, message: "Hello"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_conversational_message_with_valid_params
        @conversational_s_api.expects(:send_request).with(
          endpoint: "123123/conversational",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "text",
            text: { body: "Hello" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @conversational_s_api.send_conversational_message(
          sender_id: 123_123, recipient_number: 56_789, message: "Hello"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      def test_send_conversational_message_with_message_id
        @conversational_s_api.expects(:send_request).with(
          endpoint: "123123/conversational",
          params: {
            messaging_product: "whatsapp",
            to: 56_789,
            recipient_type: "individual",
            type: "text",
            text: { body: "Hello" },
            context: { message_id: "wamid.987654321" }
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_response(valid_contacts, valid_messages))

        message_response = @conversational_s_api.send_conversational_message(
          sender_id: 123_123, recipient_number: 56_789, message: "Hello", message_id: "wamid.987654321"
        )

        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert_predicate(message_response, :ok?)
      end

      private

      def valid_contacts
        @valid_contacts ||= [{ "input" => "1234", "wa_id" => "1234" }]
      end

      def valid_messages
        @valid_messages ||= [{ "id" => "9876" }]
      end

      def mock_response(contacts, messages)
        @conversational_s_api.stubs(:send_request).returns(valid_response(contacts, messages))
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
