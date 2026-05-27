# frozen_string_literal: true

module WhatsappSdk
  module Api
    module Responses
      class GenericErrorResponse
        attr_reader :code, :subcode, :message, :type, :data, :fbtrace_id

        def initialize(response:)
          @code = response["code"]
          @subcode = response["error_subcode"]
          @message = response["message"]
          @type = response["type"]
          @data = response["data"]
          @fbtrace_id = response["fbtrace_id"]
        end

        def self.response_error?(response:)
          return false unless response.is_a?(Hash)

          response["error"]
        end

        def self.build_from_response(response:)
          return unless response.is_a?(Hash)

          error_response = response["error"]
          return unless error_response

          new(response: error_response)
        end
      end
    end
  end
end
