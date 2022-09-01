# frozen_string_literal: true
# typed: true

module WhatsappSdk
  module Api
    module Responses
      class DataResponse
        extend ::T::Sig
        extend ::T::Helpers

        abstract!

        sig { returns(Hash) }
        attr_reader :raw_data_response

        sig { params(response: Hash).void }
        def initialize(response)
          @raw_data_response = response
        end

        sig { abstract.params(response: Hash).returns(T.nilable(DataResponse)) }
        def self.build_from_response(response:); end
      end
    end
  end
end
