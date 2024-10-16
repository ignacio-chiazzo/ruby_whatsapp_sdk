# frozen_string_literal: true

module WhatsappSdk
  module Api
    module Responses
      class SuccessResponse
        def self.success_response?(response:)
          response["success"] == true
        end
      end
    end
  end
end
