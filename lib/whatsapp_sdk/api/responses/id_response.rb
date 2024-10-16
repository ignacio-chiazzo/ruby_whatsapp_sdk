# frozen_string_literal: true

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
