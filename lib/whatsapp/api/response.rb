require_relative "../api/message_response"
require_relative "../api/error_response"

module Whatsapp
  module Api
    class Response
      attr_accessor :error, :data

      def initialize(response:)
        @data = MessageResponse.build_from_response(response: response)
        @error = ErrorResponse.build_from_response(response: response)
      end

      def ok?
        @error.nil?
      end

      def error?
        !!@error
      end
    end
  end
end
  