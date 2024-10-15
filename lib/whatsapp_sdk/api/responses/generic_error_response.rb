# frozen_string_literal: true

require_relative "error_response"

module WhatsappSdk
  module Api
    module Responses
      class GenericErrorResponse < ErrorResponse
        attr_reader :code, :subcode, :message, :type, :data, :fbtrace_id

        def initialize(response:)
          @code = response["code"]
          @subcode = response["error_subcode"]
          @message = response["message"]
          @type = response["type"]
          @data = response["data"]
          @fbtrace_id = response["fbtrace_id"]

          super(response: response)
        end

        def self.response_error?(response:)
          response["error"]
        end

        def self.build_from_response(response:)
          error_response = response["error"]
          return unless error_response

          new(response: error_response)
        end
      end
    end
  end
end
