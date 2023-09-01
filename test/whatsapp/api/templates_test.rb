# typed: true
# frozen_string_literal: true

require "test_helper"
require_relative '../../../lib/whatsapp_sdk/api/templates'

module WhatsappSdk
  module Api
    class TemplatesTest < Minitest::Test
      def setup
        client = WhatsappSdk::Api::Client.new("test_token")
        @messages_api = WhatsappSdk::Api::Messages.new(client)
        @templates_api = WhatsappSdk::Api::Templates.new(client)
      end

      ##### CREATE
      def test_create_a_template_raises_an_error_when_category_is_invalid
        error = assert_raises(WhatsappSdk::Api::Templates::InvalidCategoryError) do
          @templates_api.create(
            business_id: 123_456,
            name: "seasonal_promotion",
            language: "en_US",
            category: "RANDOM"
          )
        end

        assert_equal("Invalid Category. The possible values are: AUTHENTICATION, MARKETING and UTILITY.", error.message)
      end

      def test_create_a_template_with_valid_params
        mock_response
        # components_json = [{
        #   type: "header",
        #   parameters: [
        #     {
        #       type: "image",
        #       image: {
        #         link: "http(s)://URL"
        #       }
        #     }
        #   ]
        # }]
        components_json = []

        @templates_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "123456/message_templates",
          params: {
            name: "seasonal_promotion",
            language: "en_US",
            category: "MARKETING",
            components_json: components_json
          },
          headers: { "Content-Type" => "application/json" }
        ).returns(valid_template_response)

        template_response = @templates_api.create(
          business_id: 123_456,
          name: "seasonal_promotion",
          language: "en_US",
          category: "MARKETING",
          components_json: components_json
        )

        assert_templates_mock_response(valid_template_response, template_response)
        assert_predicate(template_response, :ok?)
      end

      ##### GET Templates
      ##### GET Message Template
      ##### Update Message Template
      ##### Delete Message Template

      private

      def mock_response
        @templates_api.stubs(:send_request).returns(valid_template_response)
        valid_template_response
      end

      def assert_templates_mock_response(expected_template_response, template_response)
        assert_ok_response(template_response)
        assert_equal(WhatsappSdk::Api::Response, template_response.class)
        assert_equal(expected_template_response["id"], template_response.raw_response["id"])
        assert_equal(expected_template_response["status"], template_response.raw_response["status"])
        assert_equal(expected_template_response["category"], template_response.raw_response["category"])
      end

      def assert_ok_response(response)
        assert_equal(WhatsappSdk::Api::Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
      end

      def valid_template_response
        @valid_template_response ||= {
          id: "123456",
          status: "PENDING",
          category: "MARKETING"
        }
      end
    end
  end
end
