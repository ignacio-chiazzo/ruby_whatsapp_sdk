# typed: true
# frozen_string_literal: true

require "test_helper"
require 'api/phone_numbers'
require 'api/client'

module WhatsappSdk
  module Api
    class PhoneNumbersTest < Minitest::Test
      include(ErrorsHelper)
      include(ApiResponseHelper)

      def setup
        client = Client.new(ENV.fetch('WHATSAPP_ACCESS_TOKEN', nil))
        @phone_numbers_api = PhoneNumbers.new(client)
      end

      def test_registered_numbers_handles_error_response
        VCR.use_cassette('phone_numbers/registered_numbers_handles_error_response') do
          response = @phone_numbers_api.registered_numbers(123_123)
          assert_unsupported_request_error("get", response, "123123", "AFZgW89DkR0hLRFJP40NTd6")
        end
      end

      def test_registered_numbers_with_success_response
        VCR.use_cassette('phone_numbers/registered_numbers_with_success_response') do
          response = @phone_numbers_api.registered_numbers(114_503_234_599_312)

          expected_phone_numbers = [registered_phone_number]
          assert_phone_numbers_success_response(expected_phone_numbers, response)
        end
      end

      def test_registered_numbers_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123123/phone_numbers?fields=#{PhoneNumbers::DEFAULT_FIELDS}"
        ).returns(
          {
            "data" => [registered_phone_number],
            "paging" => { "cursors" => { "before" => "1", "after" => "2" } }
          }
        )

        @phone_numbers_api.registered_numbers(123_123)
      end

      def test_registered_number_handles_error_response
        VCR.use_cassette('phone_numbers/registered_number_handles_error_response') do
          response = @phone_numbers_api.registered_number(123_123)
          assert_unsupported_request_error("get", response, "123123", "AlicHjOpoShf8TV_iXRm1pW")
        end
      end

      def test_registered_number_with_success_response
        VCR.use_cassette('phone_numbers/registered_number_with_success_response') do
          response = @phone_numbers_api.registered_number(107_878_721_936_019)
          assert_phone_number_success_response(registered_phone_number, response)
        end
      end

      def test_registered_number_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123123?fields=#{PhoneNumbers::DEFAULT_FIELDS}"
        ).returns(
          { "data" => [registered_phone_number] }
        )

        @phone_numbers_api.registered_number(123_123)
      end

      def test_register_number_handles_error_response
        VCR.use_cassette('phone_numbers/register_number_handles_error_response') do
          response = @phone_numbers_api.register_number(123_123, 123)
          assert_unsupported_request_error("post", response, "123123", "AsINUN3wXWCUKt1M4Uyn7Pc")
        end
      end

      def test_register_number_with_success_response
        VCR.use_cassette('phone_numbers/register_number_with_success_response') do
          response = @phone_numbers_api.register_number(107_878_721_936_019, 123_456)
          assert_ok_response(response)
        end
      end

      def test_register_number_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "123123/register",
          params: {
            messaging_product: 'whatsapp', pin: 123_456
          }
        ).returns({ "success" => true })

        response = @phone_numbers_api.register_number(123_123, 123_456)
        assert_ok_response(response)
      end

      def test_deregister_number_handles_error_response
        VCR.use_cassette('phone_numbers/deregister_number_handles_error_response') do
          response = @phone_numbers_api.deregister_number(123_123)
          assert_unsupported_request_error("post", response, "123123", "AFeF4zcpff3iqz4VbpBO2Yj")
        end
      end

      def test_deregister_number_with_success_response
        VCR.use_cassette('phone_numbers/deregister_number_with_success_response') do
          response = @phone_numbers_api.deregister_number(107_878_721_936_019)
          assert_ok_response(response)
        end
      end

      def test_deregister_number_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "123123/deregister",
          params: {}
        ).returns({ "success" => true })

        response = @phone_numbers_api.deregister_number(123_123)
        assert_ok_response(response)
      end

      private

      def registered_phone_number
        {
          "verified_name" => "Test Number",
          "code_verification_status" => "NOT_VERIFIED",
          "display_phone_number" => "+1 555-093-4873",
          "quality_rating" => "GREEN",
          "id" => "107878721936019",
          "is_official_business_account" => false,
          "account_mode" => "SANDBOX",
          "eligibility_for_api_business_global_search" => "NON_ELIGIBLE_VERIFIED_LEVEL",
          "is_pin_enabled" => true,
          "name_status" => "AVAILABLE_WITHOUT_REVIEW",
          "new_name_status" => "NONE",
          "status" => "DISCONNECTED",
          "search_visibility" => "NON_VISIBLE",
          "messaging_limit_tier" => "TIER_250"
        }
      end

      def assert_phone_numbers_success_response(expected_phone_numbers, response)
        assert_ok_response(response)
        assert_equal(expected_phone_numbers.size, response.data.phone_numbers.size)
        expected_phone_numbers.each do |expected_phone_number|
          assert_phone_number(expected_phone_number, response.data.phone_numbers.first)
        end
      end

      def assert_phone_number_success_response(expected_phone_number, response)
        assert_ok_response(response)
        assert_phone_number(expected_phone_number, response.data)
      end

      def assert_phone_number_mock_response(expected_phone_number, response)
        assert_ok_response(response)
        assert_phone_number(expected_phone_number, response.data)
      end

      def assert_phone_number(expected_phone_number, phone_number)
        [
          [expected_phone_number["id"], phone_number.id],
          [expected_phone_number["display_phone_number"], phone_number.display_phone_number],
          [expected_phone_number["quality_rating"], phone_number.quality_rating],
          [expected_phone_number["verified_name"], phone_number.verified_name],
          [expected_phone_number["code_verification_status"], phone_number.code_verification_status],
          [expected_phone_number["is_official_business_account"], phone_number.is_official_business_account],
          [expected_phone_number["account_mode"], phone_number.account_mode],
          [expected_phone_number["eligibility_for_api_business_global_search"],
           phone_number.eligibility_for_api_business_global_search],
          [expected_phone_number["is_pin_enabled"], phone_number.is_pin_enabled],
          [expected_phone_number["name_status"], phone_number.name_status],
          [expected_phone_number["new_name_status"], phone_number.new_name_status],
          [expected_phone_number["status"], phone_number.status],
          [expected_phone_number["search_visibility"], phone_number.search_visibility],
          [expected_phone_number["certificate"], phone_number.certificate]
        ].each do |expected, actual|
          if expected.nil?
            assert_nil(actual)
          else
            assert_equal(expected, actual)
          end
        end
      end
    end
  end
end
