# typed: true
# frozen_string_literal: true

require "test_helper"
require 'api/phone_numbers'
require 'api/client'

module WhatsappSdk
  module Api
    class PhoneNumbersTest < Minitest::Test
      include(ErrorsHelper)

      def setup
        client = Client.new(ENV.fetch('WHATSAPP_ACCESS_TOKEN', nil))
        @phone_numbers_api = PhoneNumbers.new(client)
      end

      def test_list_handles_error_response
        VCR.use_cassette('phone_numbers/registered_numbers_handles_error_response') do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @phone_numbers_api.list(123_123)
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("get", "123123", "AFZgW89DkR0hLRFJP40NTd6", http_error.error_info)
        end
      end

      def test_list_with_success_response
        VCR.use_cassette('phone_numbers/registered_numbers_with_success_response') do
          phone_numbers_pagination = @phone_numbers_api.list(114_503_234_599_312)

          assert_equal(1, phone_numbers_pagination.records.size)
          assert(phone_numbers_pagination.before)
          assert(phone_numbers_pagination.after)

          phone_number = phone_numbers_pagination.records.first
          assert_equal(registered_phone_number, phone_number)
        end
      end

      def test_list_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123123/phone_numbers?fields=#{PhoneNumbers::DEFAULT_FIELDS}"
        ).returns(
          {
            "data" => [registered_phone_number_hash],
            "paging" => { "cursors" => { "before" => "1", "after" => "2" } }
          }
        )

        phone_numbers_pagination = @phone_numbers_api.list(123_123)
        assert_equal(1, phone_numbers_pagination.records.size)
        phone_number = phone_numbers_pagination.records.first
        assert_equal(registered_phone_number, phone_number)
      end

      def test_get_handles_error_response
        VCR.use_cassette('phone_numbers/registered_number_handles_error_response') do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @phone_numbers_api.get(123_123)
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("get", "123123", "AlicHjOpoShf8TV_iXRm1pW", http_error.error_info)
        end
      end

      def test_get_with_success_response
        VCR.use_cassette('phone_numbers/registered_number_with_success_response') do
          phone_number = @phone_numbers_api.get(107_878_721_936_019)
          assert_equal(registered_phone_number, phone_number)
        end
      end

      def test_get_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123123?fields=#{PhoneNumbers::DEFAULT_FIELDS}"
        ).returns(
          { "data" => [registered_phone_number] }
        )

        assert(@phone_numbers_api.get(123_123))
      end

      def test_register_number_handles_error_response
        VCR.use_cassette('phone_numbers/register_number_handles_error_response') do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @phone_numbers_api.register_number(123_123, 123)
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("post", "123123", "AsINUN3wXWCUKt1M4Uyn7Pc", http_error.error_info)
        end
      end

      def test_register_number_with_success_response
        VCR.use_cassette('phone_numbers/register_number_with_success_response') do
          assert(@phone_numbers_api.register_number(107_878_721_936_019, 123_456))
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

        assert(@phone_numbers_api.register_number(123_123, 123_456))
      end

      def test_deregister_number_handles_error_response
        VCR.use_cassette('phone_numbers/deregister_number_handles_error_response') do
          http_error = assert_raises(Api::Responses::HttpResponseError) do
            @phone_numbers_api.deregister_number(123_123)
          end

          assert_equal(400, http_error.http_status)
          assert_unsupported_request_error_v2("post", "123123", "AFeF4zcpff3iqz4VbpBO2Yj", http_error.error_info)
        end
      end

      def test_deregister_number_with_success_response
        VCR.use_cassette('phone_numbers/deregister_number_with_success_response') do
          assert(@phone_numbers_api.deregister_number(107_878_721_936_019))
        end
      end

      def test_deregister_number_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "123123/deregister",
          params: {}
        ).returns({ "success" => true })

        assert(@phone_numbers_api.deregister_number(123_123))
      end

      private

      def registered_phone_number_hash
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

      def registered_phone_number
        Resource::PhoneNumber.from_hash(registered_phone_number_hash)
      end
    end
  end
end
