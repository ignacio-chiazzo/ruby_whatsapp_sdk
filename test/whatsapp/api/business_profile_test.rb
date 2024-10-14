# typed: true
# frozen_string_literal: true

require 'api/business_profile'
require 'api/client'
require 'api_response_helper'
module WhatsappSdk
  module Api
    class BusinessProfileTest < Minitest::Test
      include(ErrorsHelper)
      include(ApiResponseHelper)

      def setup
        # TODO: raise error if access token is not set
        client = Client.new(ENV.fetch('WHATSAPP_ACCESS_TOKEN', nil))
        @business_profile_api = BusinessProfile.new(client)
      end

      def test_details_handles_error_response
        VCR.use_cassette('business_profile/details_handles_error_response') do
          response = @business_profile_api.details(123_123)
          assert_unsupported_request_error("get", response, "123123", "AYMXgC3SR8dC_HM7lrwoPOZ")
        end
      end

      def test_details_accepts_fields
        fields = %w[vertical]
        VCR.use_cassette('business_profile/details_accepts_fields') do
          response = @business_profile_api.details(107_878_721_936_019, fields: fields)

          assert_ok_response(response)
          assert_equal(%w[vertical messaging_product], response.raw_response["data"][0].keys)
        end
      end

      def test_details_sends_all_fields_by_default
        VCR.use_cassette('business_profile/details_sends_all_fields_by_default') do
          response = @business_profile_api.details(107_878_721_936_019)

          assert_business_details_response(
            {
              about: nil,
              messaging_product: "whatsapp",
              address: nil,
              description: nil,
              email: nil,
              profile_picture_url: nil,
              websites: nil,
              vertical: "UNDEFINED"
            }, response
          )
        end
      end

      def test_details_with_success_response
        VCR.use_cassette('business_profile/details_with_success_response') do
          response = @business_profile_api.details(107_878_721_936_019)

          assert_business_details_response(
            {
              messaging_product: "whatsapp",
              address: "123, Main Street, New York, NY, 10001",
              description: "This is a description",
              email: "testing@gmail.com",
              profile_picture_url: nil,
              websites: ["https://www.google.com/"],
              vertical: "EDU"
            }, response
          )
        end
      end

      def test_update_returns_an_error_if_vertical_is_invalid
        params = { vertical: "invalid_vertical" }
        assert_raises(BusinessProfile::InvalidVertical) do
          @business_profile_api.update(phone_number_id: 123_123, params: params)
        end
      end

      def test_update_handles_error_response
        VCR.use_cassette('business_profile/update_handles_error_response') do
          response = @business_profile_api.update(
            phone_number_id: 123_123, params: { about: "Hey there! I am using WhatsApp." }
          )

          assert_unsupported_request_error("post", response, "123123", "Aqsz-RxXL8YZKhl3wBpoStg")
        end
      end

      def test_update_with_success_response
        VCR.use_cassette('business_profile/update_with_success_response') do
          params = {
            messaging_product: "whatsapp",
            address: "123, Main Street, New York, NY, 10001",
            description: "This is a description",
            email: "testing@gmail.com",
            websites: ["https://www.google.com"],
            vertical: "EDU"
          }
          response = @business_profile_api.update(phone_number_id: 107_878_721_936_019, params: params)

          assert_ok_success_response(response)
        end
      end

      private

      def assert_business_details_response(expected_business_profile, response)
        assert_ok_response(response)

        [
          [expected_business_profile[:about], response.data.about],
          [expected_business_profile[:messaging_product], response.data.messaging_product],
          [expected_business_profile[:address], response.data.address],
          [expected_business_profile[:description], response.data.description],
          [expected_business_profile[:email], response.data.email],
          [expected_business_profile[:websites], response.data.websites],
          [expected_business_profile[:vertical], response.data.vertical]
        ].each do |expected_value, actual_value|
          if expected_value.nil?
            assert_nil(actual_value)
          else
            assert_equal(expected_value, actual_value)
          end
        end
      end
    end
  end
end
