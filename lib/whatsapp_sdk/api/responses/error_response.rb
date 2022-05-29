# frozen_string_literal: true

module WhatsappSdk
  module Api
    module Responses
      class ErrorResponse
        attr_reader :code, :subcode, :message, :type, :data, :fbtrace_id

        def initialize(code:, subcode:, message:, type:, data:, fbtrace_id:)
          @code = code
          @subcode = subcode
          @message = message
          @type = type
          @data = data
          @fbtrace_id = fbtrace_id
        end

        def self.build_from_response(response:)
          error_response = response["error"]
          return unless error_response

          new(
            code: error_response["code"],
            subcode: error_response["error_subcode"],
            message: error_response["message"],
            type: error_response["type"],
            data: error_response["data"],
            fbtrace_id: error_response["fbtrace_id"]
          )
        end
      end
    end
  end
end
