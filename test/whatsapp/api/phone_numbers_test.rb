# frozen_string_literal: true

require "test_helper"
require_relative '../../../lib/whatsapp/api/phone_numbers'
require_relative '../../../lib/whatsapp/resource/contact_response'
require_relative '../../../lib/whatsapp/client'

module Whatsapp
  module Api
    class PhoneNumbersTest < Minitest::Test
      def setup
        client = Whatsapp::Client.new("test_token")
        @phone_numbers_api = Whatsapp::Api::PhoneNumbers.new(client)
      end

      def test_registered_numbers_handles_error_responser
        mocked_error_response = mock_error_response
        response = @phone_numbers_api.registered_numbers(123123)
        assert_mock_error_response(mocked_error_response, response)
      end

      def test_registered_numbers_with_success_response
        mock_phone_numbers_response(valid_phone_numbers_response)
        response = @phone_numbers_api.registered_numbers(123123)
        assert_phone_numbers_mock_response(valid_phone_number_response, response)
        assert(response.ok?)
      end

      def test_registered_numbers_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123123/phone_numbers"
        ).returns(valid_phone_numbers_response)

        response = @phone_numbers_api.registered_numbers(123123)
        assert_phone_numbers_mock_response(valid_phone_number_response, response)
        assert(response.ok?)
      end

      def test_registered_number_handles_error_responser
        mocked_error_response = mock_error_response
        response = @phone_numbers_api.registered_number(123123)
        assert_mock_error_response(mocked_error_response, response)
      end

      def test_registered_number_with_success_response
        mock_phone_numbers_response(valid_phone_number_response)
        response = @phone_numbers_api.registered_number(123123)
        assert_phone_number_mock_response(valid_phone_number_response, response)
        assert(response.ok?)
      end

      def test_registered_number_sends_valid_params
        @phone_numbers_api.expects(:send_request).with(
          http_method: "get",
          endpoint: "123123"
        ).returns(valid_phone_number_response)

        response = @phone_numbers_api.registered_number(123123)
        assert_phone_number_mock_response(valid_phone_number_response, response)
        assert(response.ok?)
      end

      private

      def mock_error_response
        error_response = {
          "error" => {
            "message"=> "Unsupported post request.",
            "type"=>"GraphMethodException",
            "code"=>100,
            "error_subcode"=>33,
            "fbtrace_id"=>"Au12W6oW_Np1IyF4v5YwAiU"
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
        display_phone_number: "1234", quality_rating: "GREEN", id: "1"
      )
        {
          "verified_name" => verified_name,
          "code_verification_status" => code_verification_status,
          "display_phone_number" => display_phone_number,
          "quality_rating" => quality_rating,
          "id" => id
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
              "before"=>"1",
              "after"=>"2"
            }
          }
        } 
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
      
      def assert_phone_numbers_mock_response(expected_phone_number, response)
        assert_equal(Whatsapp::Api::Response, response.class)
        assert_nil(response.error)
        assert(response.ok?)
        assert_equal(1, response.data.phone_numbers.size)
        assert_phone_number(expected_phone_number, response.data.phone_numbers.first)
      end

      def assert_phone_number_mock_response(expected_phone_number, response)
        assert_equal(Whatsapp::Api::Response, response.class)
        assert_nil(response.error)
        assert(response.ok?)
        assert_phone_number(expected_phone_number, response.data)
      end

      def assert_phone_number(expected_phone_number, phone_number)
        assert_equal(expected_phone_number["id"], phone_number.id)
        assert_equal(expected_phone_number["display_phone_number"], phone_number.display_phone_number)
        assert_equal(expected_phone_number["quality_rating"], phone_number.quality_rating)
        assert_equal(expected_phone_number["verified_name"], phone_number.verified_name)
      end
    end
  end
end
