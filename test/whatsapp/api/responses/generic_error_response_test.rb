# typed: true
# frozen_string_literal: true

require 'test_helper'
require 'api/responses/generic_error_response'

module WhatsappSdk
  module Api
    module Responses
      class GenericErrorResponseTest < Minitest::Test
        def test_response_error_returns_truthy_for_hash_with_error_key
          response = { "error" => { "message" => "Invalid OAuth token", "code" => 190 } }
          assert_equal({ "message" => "Invalid OAuth token", "code" => 190 },
                       GenericErrorResponse.response_error?(response: response))
        end

        def test_response_error_returns_nil_for_hash_without_error_key
          response = { "data" => [{ "id" => "1" }] }
          assert_nil(GenericErrorResponse.response_error?(response: response))
        end

        def test_response_error_returns_false_for_string_input
          body = '{"data":[{"text":"si tu cupón te da algún error, avísanos"}]}'
          assert_equal(false, GenericErrorResponse.response_error?(response: body))
        end

        def test_response_error_returns_false_for_nil_input
          assert_equal(false, GenericErrorResponse.response_error?(response: nil))
        end

        def test_build_from_response_returns_instance_for_hash_with_error_key
          response = { "error" => { "message" => "Invalid OAuth token", "code" => 190 } }
          result = GenericErrorResponse.build_from_response(response: response)
          assert_instance_of(GenericErrorResponse, result)
          assert_equal(190, result.code)
          assert_equal("Invalid OAuth token", result.message)
        end

        def test_build_from_response_returns_nil_for_hash_without_error_key
          response = { "data" => [{ "id" => "1" }] }
          assert_nil(GenericErrorResponse.build_from_response(response: response))
        end

        def test_build_from_response_returns_nil_for_nil_input
          assert_nil(GenericErrorResponse.build_from_response(response: nil))
        end

        def test_build_from_response_returns_nil_for_string_input
          assert_nil(GenericErrorResponse.build_from_response(response: '{"error":"x"}'))
        end
      end
    end
  end
end
