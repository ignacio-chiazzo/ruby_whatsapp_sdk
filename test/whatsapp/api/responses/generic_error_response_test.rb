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

        # Regression guard: a raw JSON string that happens to contain the substring "error"
        # (e.g. inside a template body) must NOT trigger an error. Previously String#[] was
        # used as a substring scan, causing false positives for any 200 response body
        # mentioning the word "error".
        def test_response_error_returns_false_for_string_input
          body = '{"data":[{"text":"si tu cupón te da algún error, avísanos"}]}'
          assert_equal(false, GenericErrorResponse.response_error?(response: body))
        end

        def test_response_error_returns_false_for_nil_input
          assert_equal(false, GenericErrorResponse.response_error?(response: nil))
        end
      end
    end
  end
end
