# frozen_string_literal: true
# typed: true

require_relative '../../../lib/whatsapp_sdk/api/business_profile'
require_relative '../../../lib/whatsapp_sdk/api/client'

module WhatsappSdk
  module Api
    class BusinessProfileTest < Minitest::Test
      def setup
        client = WhatsappSdk::Api::Client.new("test_token")
        @business_profile_api = WhatsappSdk::Api::BusinessProfile.new(client)
      end

      def test_details_handles_error_response
        mocked_error_response = mock_error_response
        response = @business_profile_api.details(123_123)
        assert_mock_error_response(mocked_error_response, response)
      end

      def test_details_with_success_response
        mock_business_profile_response(valid_details_response)
        response = @business_profile_api.details(123_123)
        assert_business_details_mock_response(valid_detail_response, response)
        assert_predicate(response, :ok?)
      end

      private

      def mock_error_response
        error_response = {
          "error" => {
            "message" => "Unsupported post request.",
            "type" => "GraphMethodException",
            "code" => 100,
            "error_subcode" => 33,
            "fbtrace_id" => "Au12W6oW_Np1IyF4v5YwAiU"
          }
        }
        @business_profile_api.stubs(:send_request).returns(error_response)
        error_response
      end

      def mock_business_profile_response(response)
        @business_profile_api.stubs(:send_request).returns(response)
        response
      end

      def valid_details_response(
        about: "Hey there! I am using WhatsApp.", messaging_product: "whatsapp"
      )
        {
          "data" => [
            valid_detail_response(about: about, messaging_product: messaging_product)
          ]
        }
      end

      def valid_detail_response(
        about: "Hey there! I am using WhatsApp.", messaging_product: "whatsapp"
      )
        {
          "about" => about,
          "messaging_product" => messaging_product
        }
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

      def assert_business_details_mock_response(expected_business_profile, response)
        assert_equal(WhatsappSdk::Api::Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
        assert_equal(expected_business_profile["about"], response.data.about)
        assert_equal(expected_business_profile["messaging_product"], response.data.messaging_product)
      end
    end
  end
end
