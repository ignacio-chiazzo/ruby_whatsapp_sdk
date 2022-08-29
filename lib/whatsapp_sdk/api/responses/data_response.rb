# frozen_string_literal: true
# typed: true

module WhatsappSdk
  module Api
    module Responses
      class DataResponse
        extend T::Sig
        extend T::Helpers
      
        abstract!

        attr_reader :raw_data_response

        def initialize(response)
          @raw_data_response = response
        end

        sig { abstract.params(response: Hash).returns(T.nilable(DataResponse))}
        def self.build_from_response(response:) # rubocop:disable Lint/UnusedMethodArgument:
        end
      end
    end
  end
end
