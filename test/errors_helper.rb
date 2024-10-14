# typed: false
# frozen_string_literal: true

module ErrorsHelper
  def assert_unsupported_request_error(http_method, response, object_id, fb_trace_id)
    assert_error_response(
      {
        code: 100,
        error_subcode: 33,
        message: "Unsupported #{http_method} request. Object with ID '#{object_id}' does not exist, " \
                 "cannot be loaded due to missing permissions, or does not support this operation. " \
                 "Please read the Graph API documentation at https://developers.facebook.com/docs/graph-api",
        fbtrace_id: fb_trace_id
      },
      response
    )
  end

  def generic_error_response
    {
      "error" => {
        "message" => "Unsupported get request.",
        "type" => "GraphMethodException",
        "code" => 100,
        "error_subcode" => 33,
        "fbtrace_id" => "Au12W6oW_Np1IyF4v5YwAiU"
      }
    }
  end

  def mock_error_response(api:)
    error_response = generic_error_response
    api.stubs(:send_request).returns(generic_error_response)
    error_response
  end

  # delete!!!
  def assert_mock_error_response(
    mocked_error, response, error_class = WhatsappSdk::Api::Responses::GenericErrorResponse
  )
    refute_predicate(response, :ok?)
    assert_nil(response.data)
    error = response.error
    assert_equal(error_class, error.class)
    assert_equal(mocked_error["error"]["code"], error.code)
    assert_equal(mocked_error["error"]["error_subcode"], error.subcode)
    assert_equal(mocked_error["error"]["message"], error.message)
    assert_equal(mocked_error["error"]["fbtrace_id"], error.fbtrace_id)
  end

  # error: { code:, error_subcode:, message:, fbtrace_id: }
  def assert_error_response(expected_error, response)
    refute_predicate(response, :ok?)
    assert_nil(response.data)
    error = response.error
    assert_equal(expected_error[:code], error.code)
    assert_equal(expected_error[:error_subcode], error.subcode)
    assert_equal(expected_error[:message], error.message)
    assert_equal(expected_error[:fbtrace_id], error.fbtrace_id)
  end
end
