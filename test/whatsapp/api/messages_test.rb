require "test_helper"
require_relative '../../../lib/whatsapp/api/messages'
require_relative '../../../lib/whatsapp/resource/address'
require_relative '../../../lib/whatsapp/resource/contact'
require_relative '../../../lib/whatsapp/resource/phone_number'
require_relative '../../../lib/whatsapp/resource/url'
require_relative '../../../lib/whatsapp/resource/email'
require_relative '../../../lib/whatsapp/resource/org'
require_relative '../../../lib/whatsapp/resource/name'
require_relative '../../../lib/whatsapp/client'

module Whatsapp
  module Api
    class MessagesTest < Minitest::Test
      def setup
        client = Whatsapp::Client.new("test_token")
        @messages_api = Whatsapp::Api::Messages.new(client)
      end

      def test_send_text_handles_error_response
        mocked_error_response = mock_error_response
        response = @messages_api.send_text(
          sender_id: 123123, recipient_number: "56789", message: "hola"
        )
        assert_mock_error_response(mocked_error_response, response)
      end

      def test_send_text_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_text(
          sender_id: 123123, recipient_number: "56789", message: "hola"
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_text_message_with_valid_params
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "text",
            text: { body: "hola" }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_text(
          sender_id: 123123, recipient_number: "56789", message: "hola"
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_location_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_location(
          sender_id: 123123, recipient_number: "56789", 
          longitude: 45.4215, latitude: 75.6972, name: "nacho", address: "141 cooper street"
        )
          
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
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
            to: "56789",
            recepient_type: "individual",
            type: "location",
            "location": { 
              "longitude": longitude,
              "latitude": latitude,
              "name": name,
              "address": address
            }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_location(
          sender_id: 123123, recipient_number: "56789",
          longitude: longitude, latitude: latitude, name: name, address: address
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_image_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Whatsapp::Api::Messages::MissingArgumentError) do
          @messages_api.send_image(
            sender_id: 123123, recipient_number: "56789",
            image_id: nil, link: nil, caption: ""
          )
        end
      end

      def test_send_image_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_image(
          sender_id: 123123, recipient_number: "56789",
          image_id: 123, link: nil, caption: ""
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_image_message_with_a_link
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "image",
            image: { link: image_link, caption: "Ignacio Chiazzo Profile" }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_image(
          sender_id: 123123, recipient_number: "56789",
          link: image_link, caption: "Ignacio Chiazzo Profile"
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_image_message_with_an_image_id
        image_id = "12345"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "image",
            image: { id: image_id, caption: "Ignacio Chiazzo Profile" }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_image(
          sender_id: 123123, recipient_number: "56789",
          image_id: image_id, caption: "Ignacio Chiazzo Profile"
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_audio_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_audio(
          sender_id: 123123, recipient_number: "56789", link: "1234"
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_audio_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Whatsapp::Api::Messages::MissingArgumentError) do
          @messages_api.send_audio(
            sender_id: 123123, recipient_number: "56789", link: nil, audio_id: nil
          )
        end
      end

      def test_send_audio_message_with_a_link
        audio_link = "1234"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "audio",
            audio: { link: audio_link }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_audio(
          sender_id: 123123, recipient_number: "56789", link: audio_link
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_audio_message_with_an_audio_id
        audio_id = "12345"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "audio",
            audio: { id: audio_id }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_audio(
          sender_id: 123123, recipient_number: "56789", audio_id: audio_id
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_video_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Whatsapp::Api::Messages::MissingArgumentError) do
          @messages_api.send_video(
            sender_id: 123123, recipient_number: "56789", link: nil, video_id: nil
          )
        end
      end

      def test_send_video_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_video(
          sender_id: 123123, recipient_number: "56789",
          video_id: 123, link: nil, caption: ""
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_video_message_with_a_link
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "video",
            video: { link: video_link, caption: "Ignacio Chiazzo Profile" }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_video(
          sender_id: 123123, recipient_number: "56789",
          link: video_link, caption: "Ignacio Chiazzo Profile"
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_video_message_with_an_video_id
        video_id = "12345"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "video",
            video: { id: video_id, caption: "Ignacio Chiazzo Profile" }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_video(
          sender_id: 123123, recipient_number: "56789",
          video_id: video_id, caption: "Ignacio Chiazzo Profile"
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_document_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Whatsapp::Api::Messages::MissingArgumentError) do
          @messages_api.send_document(
            sender_id: 123123, recipient_number: "56789", link: nil, document_id: nil
          )
        end
      end

      def test_send_document_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_document(
          sender_id: 123123, recipient_number: "56789",
          document_id: 123, link: nil, caption: ""
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_document_message_with_a_link
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "document",
            document: { link: document_link, caption: "Ignacio Chiazzo Profile" }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_document(
          sender_id: 123123, recipient_number: "56789",
          link: document_link, caption: "Ignacio Chiazzo Profile"
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_document_message_with_an_document_id
        document_id = "12345"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "document",
            document: { id: document_id, caption: "Ignacio Chiazzo Profile" }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_document(
          sender_id: 123123, recipient_number: "56789",
          document_id: document_id, caption: "Ignacio Chiazzo Profile"
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_sticker_raises_an_error_if_link_and_image_are_not_provided
        assert_raises(Whatsapp::Api::Messages::MissingArgumentError) do
          @messages_api.send_sticker(
            sender_id: 123123, recipient_number: "56789", link: nil, sticker_id: nil
          )
        end
      end

      def test_send_sticker_message_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_sticker(
          sender_id: 123123, recipient_number: "56789",
          sticker_id: 123, link: nil
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_sticker_message_with_a_link
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "sticker",
            sticker: { link: sticker_link }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_sticker(
          sender_id: 123123, recipient_number: "56789", link: sticker_link
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_sticker_message_with_an_sticker_id
        sticker_id = "12345"
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "sticker",
            sticker: { id: sticker_id }
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_sticker(
          sender_id: 123123, recipient_number: "56789", sticker_id: sticker_id
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end
   
      def test_send_contacts_with_success_response
        mock_response(valid_contacts, valid_messages)
        message_response = @messages_api.send_contacts(
          sender_id: 123123, recipient_number: "56789", contacts: [create_contact]
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      def test_send_contacts_with_a_valid_response
        contacts = [create_contact]
        @messages_api.expects(:send_request).with(
          endpoint: "123123/messages",
          params: {
            messaging_product: "whatsapp",
            to: "56789",
            recepient_type: "individual",
            type: "contacts",
            contacts: contacts.map(&:to_h)
          }
        ).returns(valid_response(valid_contacts, valid_messages))
        
        message_response = @messages_api.send_contacts(
          sender_id: 123123, recipient_number: "56789", contacts: contacts
        )
        assert_mock_response(valid_contacts, valid_messages, message_response)
        assert(message_response.ok?)
      end

      private

      def mock_error_response
        error_response = {
          "error" => {
            "message"=> "Unsupported post request.",
            "type"=>"GraphMethodException",
            "code"=>100,
            "error_subcode"=>33,
            "fbtrace_id"=>"Au93W6oW_Np0PyF7v5YwAiU"
          }
        }
        @messages_api.stubs(:send_request).returns(error_response)
        error_response
      end

      def assert_mock_error_response(mocked_error, response)
        assert_equal(false, response.ok?)
        assert_nil(response.data)
        error = response.error
        assert_equal(mocked_error["error"]["code"], error.code)
        assert_equal(mocked_error["error"]["error_subcode"], error.subcode)
        assert_equal(mocked_error["error"]["message"], error.message)
        assert_equal(mocked_error["error"]["error_subcode"], error.subcode)
        assert_equal(mocked_error["error"]["fbtrace_id"], error.fbtrace_id)
      end

      def create_addresses
        address_1 = Whatsapp::Resource::Address.new(
          street: "STREET",
          city: "CITY",
          state: "STATE",
          zip: "ZIP",
          country: "COUNTRY",
          country_code: "COUNTRY_CODE",
          type: Whatsapp::Resource::Address::ADDRESS_TYPE[:home]
        )
        address_2 = Whatsapp::Resource::Address.new(
          street: "STREET",
          city: "CITY",
          state: "STATE",
          zip: "ZIP",
          country: "COUNTRY",
          country_code: "COUNTRY_CODE",
          type: Whatsapp::Resource::Address::ADDRESS_TYPE[:work]
        )

        [address_1, address_2]
      end

      def create_emails
        email_1 = Whatsapp::Resource::Email.new(
          email: "ignacio@gmail.com", type: Whatsapp::Resource::Email::EMAIL_TYPE[:work]
        )

        email_2 = Whatsapp::Resource::Email.new(
          email: "ignacio2@gmail.com", type: Whatsapp::Resource::Email::EMAIL_TYPE[:home]
        )

        [email_1, email_2]
      end

      def create_name
        Whatsapp::Resource::Name.new(
          formatted_name: "ignacio chiazzo",
          first_name: "ignacio",
          last_name: "chiazo",
          middle_name: "jose",
          suffix: "ch",
          prefix: "ig"
        )
      end

      def create_org
        Whatsapp::Resource::Org.new(company: "ignacioCo", department: "Engineering", title: "ignacioOrg")
      end

      def create_phones
        phone_1 = Whatsapp::Resource::PhoneNumber.new(
          phone: "1234567", type: Whatsapp::Resource::PhoneNumber::PHONE_NUMBER_TYPE[:home], wa_id: "1234"
        )
        phone_2 = Whatsapp::Resource::PhoneNumber.new(
          phone: "1234567", type: Whatsapp::Resource::PhoneNumber::PHONE_NUMBER_TYPE[:work], wa_id: "1234"
        )

        [phone_1, phone_2]
      end

      def create_urls
        url_1 = Whatsapp::Resource::Url.new(url: "1234567", type: Whatsapp::Resource::Address::ADDRESS_TYPE[:home])
        url_2 = Whatsapp::Resource::Url.new(url: "1234567", type: Whatsapp::Resource::Address::ADDRESS_TYPE[:work])

        [url_1, url_2]
      end

      def create_contact
        Whatsapp::Resource::Contact.new(
          addresses: create_addresses,
          birthday: "2019_01_01",
          emails: create_emails, 
          name: create_name,
          org: create_org,
          phones: create_phones,
          urls: create_urls
        )
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
        valid_contacts ||= [{"input"=>"1234", "wa_id"=>"1234"}]
      end

      def valid_messages
        valid_messages ||= [{"id"=>"9876"}]
      end

      def mock_response(contacts, messages)
        @messages_api.stubs(:send_request).returns(valid_response(contacts, messages))
        valid_response(contacts, messages)
      end

      def valid_response(contacts, messages)
        valid_response ||= { "messaging_product"=>"whatsapp", "contacts" => contacts, "messages" => messages }
      end
      
      def assert_mock_response(expected_contacts, expected_messages, message_response)
        assert_equal(Whatsapp::Api::MessageResponse, message_response.class)
        assert_nil(message_response.error)
        assert(message_response.ok?)
        assert_equal(1, message_response.data.contacts.size)
        assert_contacts([{"input"=>"1234", "wa_id"=>"1234"}], message_response.data.contacts)
        
        assert_equal(1, message_response.data.messages.size)
        assert_messages([{"id"=>"9876"}], message_response.data.messages)
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
