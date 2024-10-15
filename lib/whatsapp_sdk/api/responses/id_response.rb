# frozen_string_literal: true

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class IdResponse
        attr_accessor :id

        def initialize(id)
          @id = id
        end
      end
    end
  end
end
