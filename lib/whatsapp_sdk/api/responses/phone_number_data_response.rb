# frozen_string_literal: true
# typed: true

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class PhoneNumberDataResponse < DataResponse
        attr_accessor :id, :verified_name, :display_phone_number, :quality_rating

        def initialize(response)
          @id = response["id"]
          @verified_name = response["verified_name"]
          @display_phone_number = response["display_phone_number"]
          @quality_rating = response["quality_rating"]
          super(response)
        end

        sig { override.params(response: Hash).returns(T.nilable(DataResponse)) }
        def self.build_from_response(response:)
          return unless response["id"]

          new(response)
        end
      end
    end
  end
end
