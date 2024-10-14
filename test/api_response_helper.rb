# typed: false
# frozen_string_literal: true

module ApiResponseHelper
  def assert_ok_response(response)
    assert_equal(WhatsappSdk::Api::Response, response.class)
    assert_nil(response.error)
    assert_predicate(response, :ok?)
  end
end
