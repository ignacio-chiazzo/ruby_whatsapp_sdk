# frozen_string_literal: true
# typed: true

require_relative "../request"
require_relative "data_response"
require_relative "../../resource/message"
require_relative "../../resource/contact_response"

module WhatsappSdk
  module Api
    module Responses
      class ReadMessageDataResponse < DataResponse
        attr_reader :success

        def initialize(response:)
          @success = response["success"]
          super(response)
        end

        sig { override.params(response: Hash).returns(T.nilable(DataResponse)) }
        def self.build_from_response(response:)
          return if response["error"]

          new(response: response)
        end
      end
    end
  end
end
