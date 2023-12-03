# typed: true
# frozen_string_literal: true

require 'api/business_profile'
require 'api/client'

module WhatsappSdk
  module Api
    class BusinessProfileTest < Minitest::Test
      include(ErrorsHelper)

      def setup
        client = Client.new("test_token")
        @business_profile_api = BusinessProfile.new(client)
      end

      def test_details_handles_error_response
        mocked_error_response = mock_error_response(api: @business_profile_api)
        response = @business_profile_api.details(123_123)
        assert_mock_error_response(mocked_error_response, response, Responses::MessageErrorResponse)
      end

      def test_details_with_success_response
        mock_business_profile_response(valid_details_response)
        response = @business_profile_api.details(123_123)
        assert_business_details_mock_response(valid_detail_response, response)
        assert_predicate(response, :ok?)
      end

      def test_update_handles_error_response
        mocked_error_response = mock_error_response(api: @business_profile_api)
        response = @business_profile_api.update(phone_number_id: 123_123, params: valid_detail_response)
        assert_mock_error_response(mocked_error_response, response, Responses::MessageErrorResponse)
      end

      def test_update_with_success_response
        mock_business_profile_response(valid_update_response)
        response = @business_profile_api.update(phone_number_id: 123_123, params: valid_detail_response)
        assert_update_details_mock_response(valid_update_response, response)
        assert_predicate(response, :ok?)
      end

      private

      def mock_business_profile_response(response)
        @business_profile_api.stubs(:send_request).returns(response)
        response
      end

      # this is a hash of a valid business profile response from API
      def valid_details_response(
        about: "Hey there! I am using WhatsApp.", messaging_product: "whatsapp",
        address: "123, Main Street, New York, NY, 10001", description: "This is a description",
        email: "testing@gmail.com", websites: ["https://www.google.com"], vertical: "EDU"
      )
        {
          "data" => [
            valid_detail_response(about: about, messaging_product: messaging_product,
                                  address: address, description: description, email: email,
                                  websites: websites, vertical: vertical)
          ]
        }
      end

      # this is a hash of a valid business profile
      def valid_detail_response(
        about: "Hey there! I am using WhatsApp.", messaging_product: "whatsapp",
        address: "123, Main Street, New York, NY, 10001", description: "This is a description",
        email: "testing@gmail.com", websites: ["https://www.google.com"], vertical: "EDU"
      )
        {
          "about" => about,
          "messaging_product" => messaging_product,
          "address" => address,
          "description" => description,
          "email" => email,
          "websites" => websites,
          "vertical" => vertical
        }
      end

      def valid_update_response
        {
          "success" => true
        }
      end

      def assert_business_details_mock_response(expected_business_profile, response)
        assert_equal(Response, response.class)
        assert_equal(Responses::BusinessProfileDataResponse, response.data.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
        assert_equal(expected_business_profile["about"], response.data.about)
        assert_equal(expected_business_profile["messaging_product"], response.data.messaging_product)
        assert_equal(expected_business_profile["address"], response.data.address)
        assert_equal(expected_business_profile["description"], response.data.description)
        assert_equal(expected_business_profile["email"], response.data.email)
        assert_equal(expected_business_profile["websites"], response.data.websites)
        assert_equal(expected_business_profile["vertical"], response.data.vertical)
      end

      def assert_update_details_mock_response(expected_response, response)
        assert_equal(Response, response.class)
        assert_equal(Responses::SuccessResponse, response.data.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
        assert_equal(expected_response["success"], response.data.success?)
      end
    end
  end
end
