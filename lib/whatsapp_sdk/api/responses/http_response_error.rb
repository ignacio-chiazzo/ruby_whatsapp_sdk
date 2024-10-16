# frozen_string_literal: true

module WhatsappSdk
  module Api
    module Responses
      class HttpResponseError < StandardError
        attr_reader :http_status, :body, :error_info

        def initialize(http_status:, body:)
          super
          @http_status = http_status
          @body = body
          @error_info = GenericErrorResponse.build_from_response(response: body)
        end
      end
    end
  end
end
