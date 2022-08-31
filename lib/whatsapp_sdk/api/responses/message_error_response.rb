# frozen_string_literal: true
# typed: true

require_relative "error_response"

module WhatsappSdk
  module Api
    module Responses
      class MessageErrorResponse < ErrorResponse
        attr_reader :code, :subcode, :message, :type, :data, :fbtrace_id

        sig { params(response: Hash).void }
        def initialize(response:)
          @code = response["code"]
          @subcode = response["error_subcode"]
          @message = response["message"]
          @type = response["type"]
          @data = response["data"]
          @fbtrace_id = response["fbtrace_id"]
          super(response: response)
        end

        sig { override.params(response: Hash).returns(T.nilable(DataResponse)) }
        def self.build_from_response(response:)
          error_response = response["error"]
          return unless error_response

          new(response: error_response)
        end
      end
    end
  end
end
