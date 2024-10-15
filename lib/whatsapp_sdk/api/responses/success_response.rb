# frozen_string_literal: true

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class SuccessResponse < DataResponse
        def initialize(response:)
          @success = response["success"]
          super(response)
        end

        def self.success_response?(response:)
          response["success"] == true
        end

        def self.build_from_response(response:)
          return unless response["success"]

          new(response: response)
        end

        def success?
          @success
        end
      end
    end
  end
end
