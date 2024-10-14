# typed: false
# frozen_string_literal: true

require_relative '../lib/whatsapp_sdk/api/response'
require_relative '../lib/whatsapp_sdk/api/responses/success_response'

module ApiResponseHelper
  def assert_ok_response(response)
    assert_equal(WhatsappSdk::Api::Response, response.class)
    assert_nil(response.error)
    assert_predicate(response, :ok?)
  end

  def assert_ok_success_response(response)
    assert_ok_response(response)
    assert_equal(WhatsappSdk::Api::Responses::SuccessResponse, response.data.class)
    assert_predicate(response.data, :success?)
  end
end
