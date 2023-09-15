# typed: true
# frozen_string_literal: true

require "test_helper"
require 'api/phone_numbers'
require 'resource/contact_response'
require 'api/client'

module WhatsappSdk
  module Api
    class PhoneNumbersTest < Minitest::Test
      def setup
        client = WhatsappSdk::Api::Client.new("test_token")
        @phone_numbers_api = WhatsappSdk::Api::PhoneNumbers.new(client)
      end

      def test_registered_numbers_handles_error_response
        mocked_error_response = mock_error_response
        response = @phone_numbers_api.registered_numbers(123_123)
        assert_mock_error_response(mocked_error_response, response)
      end

      def test_registered_numbers_with_success_response
        mock_phone_numbers_response(valid_phone_numbers_response)
        response = @phone_numbers_api.registered_numbers(123_123)
        assert_phone_numbers_mock_response(valid_phone_number_response, response)
        assert_predicate(response, :ok?)
      end

      def test_registered_numbers_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123123/phone_numbers?fields=#{WhatsappSdk::Api::PhoneNumbers::DEFAULT_FIELDS}"
        ).returns(valid_phone_numbers_response)

        response = @phone_numbers_api.registered_numbers(123_123)
        assert_phone_numbers_mock_response(valid_phone_number_response, response)
        assert_predicate(response, :ok?)
      end

      def test_registered_number_handles_error_response
        mocked_error_response = mock_error_response
        response = @phone_numbers_api.registered_number(123_123)
        assert_mock_error_response(mocked_error_response, response)
      end

      def test_registered_number_with_success_response
        mock_phone_numbers_response(valid_phone_number_response)
        response = @phone_numbers_api.registered_number(123_123)
        assert_phone_number_mock_response(valid_phone_number_response, response)
        assert_predicate(response, :ok?)
      end

      def test_registered_number_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123123?fields=#{WhatsappSdk::Api::PhoneNumbers::DEFAULT_FIELDS}"
        ).returns(valid_phone_number_response)

        response = @phone_numbers_api.registered_number(123_123)
        assert_phone_number_mock_response(valid_phone_number_response, response)
        assert_predicate(response, :ok?)
      end

      def test_register_number_handles_error_response
        mocked_error_response = invalid_register_number_response
        response = @phone_numbers_api.register_number(123_123, 123)
        assert_mock_error_response(mocked_error_response, response)
      end

      def test_register_number_with_success_response
        mock_phone_numbers_response({ "success" => true })
        response = @phone_numbers_api.register_number(123_123, 123_456)

        assert_equal(WhatsappSdk::Api::Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
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
        assert_equal(WhatsappSdk::Api::Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
      end

      def test_deregister_number_handles_error_response
        mocked_error_response = invalid_deregister_number_response
        response = @phone_numbers_api.deregister_number(123_123)
        assert_mock_error_response(mocked_error_response, response)
      end

      def test_deregister_number_with_success_response
        mock_phone_numbers_response({ "success" => true })
        response = @phone_numbers_api.deregister_number(123_123)

        assert_equal(WhatsappSdk::Api::Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
      end

      def test_deregister_number_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "post",
          endpoint: "123123/deregister",
          params: {}
        ).returns({ "success" => true })

        response = @phone_numbers_api.deregister_number(123_123)
        assert_equal(WhatsappSdk::Api::Response, response.class)
        assert_nil(response.error)
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
        @phone_numbers_api.stubs(:send_request).returns(error_response)
        error_response
      end

      def mock_phone_numbers_response(response)
        @phone_numbers_api.stubs(:send_request).returns(response)
        response
      end

      def valid_phone_number_response(
        verified_name: "Test Number", code_verification_status: "NOT_VERIFIED",
        display_phone_number: "1234", quality_rating: "GREEN", id: "1", is_official_business_account: false,
        account_mode: "LIVE", eligibility_for_api_business_global_search: "NON_ELIGIBLE_UNDEFINED_COUNTRY",
        is_pin_enabled: false, name_status: "APPROVED", new_name_status: "NONE", status: "CONNECTED",
        search_visibility: "VISIBLE"
      )
        {
          "verified_name" => verified_name,
          "code_verification_status" => code_verification_status,
          "display_phone_number" => display_phone_number,
          "quality_rating" => quality_rating,
          "id" => id,
          "is_official_business_account" => is_official_business_account,
          "account_mode" => account_mode,
          "eligibility_for_api_business_global_search" => eligibility_for_api_business_global_search,
          "is_pin_enabled" => is_pin_enabled,
          "name_status" => name_status,
          "new_name_status" => new_name_status,
          "status" => status,
          "search_visibility" => search_visibility
        }
      end

      def valid_phone_numbers_response(
        verified_name: "Test Number", code_verification_status: "NOT_VERIFIED",
        display_phone_number: "1234", quality_rating: "GREEN", id: "1"
      )
        {
          "data" => [
            valid_phone_number_response(
              verified_name: verified_name, code_verification_status: code_verification_status,
              display_phone_number: display_phone_number, quality_rating: quality_rating, id: id
            )
          ],
          "paging" => {
            "cursors" => {
              "before" => "1",
              "after" => "2"
            }
          }
        }
      end

      def invalid_register_number_response
        error_response = {
          "error" =>
            {
              "message" => "(#100) Param pin must be 6 characters long.",
              "type" => "OAuthException",
              "code" => 100,
              "fbtrace_id" => "AVU2ojfLmjKZSKbkWqjA_Uc"
            }
        }

        @phone_numbers_api.stubs(:send_request).returns(error_response)
        error_response
      end

      def invalid_deregister_number_response
        error_response = {
          "error" =>
            {
              "message" => "(#100) Invalid parameter",
              "type" => "OAuthException",
              "code" => 100,
              "error_data" => "Phone number not registered on the Whatsapp Business Platform.",
              "error_subcode" => 133_010,
              "fbtrace_id" => "A2iaN-Erjaze-0ABvoagZFI"
            }
        }

        @phone_numbers_api.stubs(:send_request).returns(error_response)
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
        assert_equal(mocked_error["error"]["fbtrace_id"], error.fbtrace_id)
      end

      def assert_phone_numbers_mock_response(expected_phone_number, response)
        assert_equal(WhatsappSdk::Api::Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
        assert_equal(1, response.data.phone_numbers.size)
        assert_phone_number(expected_phone_number, response.data.phone_numbers.first)
      end

      def assert_phone_number_mock_response(expected_phone_number, response)
        assert_equal(WhatsappSdk::Api::Response, response.class)
        assert_nil(response.error)
        assert_predicate(response, :ok?)
        assert_phone_number(expected_phone_number, response.data)
      end

      def assert_phone_number(expected_phone_number, phone_number)
        assert_equal(expected_phone_number["id"], phone_number.id)
        assert_equal(expected_phone_number["display_phone_number"], phone_number.display_phone_number)
        assert_equal(expected_phone_number["quality_rating"], phone_number.quality_rating)
        assert_equal(expected_phone_number["verified_name"], phone_number.verified_name)
        assert_equal(expected_phone_number["code_verification_status"], phone_number.code_verification_status)
        assert_equal(expected_phone_number["is_official_business_account"], phone_number.is_official_business_account)
        assert_equal(expected_phone_number["account_mode"], phone_number.account_mode)
        assert_equal(expected_phone_number["eligibility_for_api_business_global_search"],
                     phone_number.eligibility_for_api_business_global_search)
        assert_equal(expected_phone_number["is_pin_enabled"], phone_number.is_pin_enabled)
        assert_equal(expected_phone_number["name_status"], phone_number.name_status)
        assert_equal(expected_phone_number["new_name_status"], phone_number.new_name_status)
        assert_equal(expected_phone_number["status"], phone_number.status)
        assert_equal(expected_phone_number["search_visibility"], phone_number.search_visibility)
        assert_equal(expected_phone_number["certificate"], phone_number.certificate)
      end
    end
  end
end
