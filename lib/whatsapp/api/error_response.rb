module Whatsapp
  module Api
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
          code: error_response.dig("code"),
          subcode: error_response.dig("error_subcode"),
          message: error_response.dig("message"),
          type: error_response.dig("type"),
          data: error_response.dig("data"),
          fbtrace_id: error_response.dig("fbtrace_id")
        )
      end
    end
  end
end
