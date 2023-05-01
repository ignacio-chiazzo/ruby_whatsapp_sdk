# typed: true
# frozen_string_literal: true

require "test_helper"

module WhatsappSdk
  module Resource
    module Resource
      class TemplatesTest < Minitest::Test
        def setup
          client = WhatsappSdk::Api::Client.new("test_token")
          @templates_api = WhatsappSdk::Api::Messages.new(client)
        end

        ##### CREATE
        def test_create_a_template_raises_an_error_when_component_and_component_json_are_not_provided
          error = assert_raises(WhatsappSdk::Api::Templates::MissingArgumentError) do
            @templates_api.send_template(
              name: "seasonal_promotion", 
              language: "en_US",
              category: "MARKETING",
            )
          end
  
          assert_equal("components or components_json is required", error.message)
        end

        def test_create_a_template_sends_the_right_params
          components_json = [{
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

          @templates_api.expects(:send_request).with(
            http_method: "get",
            endpoint: "123456/message_templates",
            params: {
              name: "seasonal_promotion",
              language: "en_US",
              category: "MARKETING",
              components_json: components_json
          ).returns(valid_template_response)
  
          response = @medias_api.create_template(
            sender_id: 123456,  
            name: "seasonal_promotion",
            language: "en_US",
            category: "MARKETING",
            components_json: components_json
          )
          assert_templates_mock_response(valid_template_response, response)
          assert_predicate(response, :ok?)
        end

        ##### GET Templates
        ##### GET Message Template
        ##### Update Message Template

        ##### Delete Message Template
        def test_delete_media_handles_error_response
          # mocked_error_response = mock_error_response
          # response = @medias_api.delete(media_id: "1")
          # assert_mock_error_response(mocked_error_response, response)
        end
  
        def test_delete_media_with_success_response
          # success_response = { "success" => true }
          # mock_get_media_response(success_response)
          # response = @medias_api.delete(media_id: "123_123")
  
          # validate_sucess_data_response(response)
        end
  
        def test_delete_media_by_name_sends_valid_params
          # @medias_api.expects(:send_request).with(
          #   http_method: "delete",
          #   endpoint: "123456/1",
          #   name: "order_confirmation"
          # ).returns({ "success" => true })
  
          # response = @medias_api.delete(sender_id: 123456, name: "order_confirmation")
          # validate_sucess_data_response(response)
        end

        def test_delete_media_by_name_and_hsm_id_sends_valid_params
          # @medias_api.expects(:send_request).with(
          #   http_method: "delete",
          #   endpoint: "123456/1",
          #   name: "order_confirmation"
          # ).returns({ "success" => true })
  
          # response = @medias_api.delete(sender_id: 123456, name: "order_confirmation")
          # validate_sucess_data_response(response)
        end

        private 

        def validate_sucess_data_response
          # TODO!
        end

        def assert_templates_mock_response(expected_media_response, response)
          assert_ok_response(response)
          # TODO
          assert_equal(WhatsappSdk::Api::Responses::MessageDataResponse, response.data.class)
          assert_equal(expected_media_response["id"], response.data.id)
          assert_equal(expected_media_response["url"], response.data.url)
          assert_equal(expected_media_response["mime_type"], response.data.mime_type)
          assert_equal(expected_media_response["sha256"], response.data.sha256)
          assert_equal(expected_media_response["file_size"], response.data.file_size)
          assert_equal(expected_media_response["messaging_product"], response.data.messaging_product)
        end

        def valid_template_response
          # TODO: Update this response
          {
            "url" => "www.ignaciochiazzo.com",
            "mime_type" => "image/jpeg",
            "sha256" => "821858a6a2f4fb2f0860f646924321dfbcd34d1af2a692e5aeec0b4bd2219ade",
            "file_size" => 1170,
            "id" => "123456",
            "messaging_product" => "whatsapp"
          }
        end
      end
    end
  end
end
