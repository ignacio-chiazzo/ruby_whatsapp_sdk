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

  def assert_unsupported_request_error_v2(
    http_method, object_id, fb_trace_id, error_info, type = "GraphMethodException"
  )
    assert_error_info(
      {
        code: 100,
        error_subcode: 33,
        type: type,
        message: "Unsupported #{http_method} request. Object with ID '#{object_id}' does not exist, " \
                 "cannot be loaded due to missing permissions, or does not support this operation. " \
                 "Please read the Graph API documentation at https://developers.facebook.com/docs/graph-api",
        fbtrace_id: fb_trace_id
      },
      error_info
    )
  end

  def assert_error_info(expected_error, error)
    [
      [expected_error[:message], error.message],
      [expected_error[:type], error.type],
      [expected_error[:code], error.code],
      [expected_error[:error_subcode], error.subcode],
      [expected_error[:fbtrace_id], error.fbtrace_id]
    ].each do |expected, actual|
      if expected.nil?
        assert_nil(actual)
      else
        assert_equal(expected, actual)
      end
    end
  end

  def assert_error_response(expected_error, response)
    refute_predicate(response, :ok?)
    assert_nil(response.data)
    error = response.error
    [
      [expected_error[:code], error.code],
      [expected_error[:error_subcode], error.subcode],
      [expected_error[:message], error.message],
      [expected_error[:fbtrace_id], error.fbtrace_id]
    ].each do |expected, actual|
      if expected.nil?
        assert_nil(actual)
      else
        assert_equal(expected, actual)
      end
    end
  end
end
