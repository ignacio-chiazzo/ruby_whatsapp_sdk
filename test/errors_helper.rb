module ErrorsHelper
  def assert_error_response(expected_error_hash, response)
    refute_predicate(response, :ok?)
    assert_nil(response.data)
    error = response.error
    assert_equal(expected_error_hash["error"]["code"], error.code)
    assert_equal(expected_error_hash["error"]["error_subcode"], error.subcode)
    assert_equal(expected_error_hash["error"]["message"], error.message)
    assert_equal(expected_error_hash["error"]["error_subcode"], error.subcode)
    assert_equal(expected_error_hash["error"]["fbtrace_id"], error.fbtrace_id)
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
end