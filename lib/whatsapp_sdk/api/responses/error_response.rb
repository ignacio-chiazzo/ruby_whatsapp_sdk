# frozen_string_literal: true
# typed: true

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class ErrorResponse < DataResponse
        attr_accessor :error, :status

        def initialize(response:)
          @error = response["error"]
          @status = response["status"]
          super(response)
        end

        sig { override.params(response: Hash).returns(T.nilable(DataResponse))}
        def self.build_from_response(response:)
          return unless response["error"]

          new(response: response)
        end
      end
    end
  end
end
