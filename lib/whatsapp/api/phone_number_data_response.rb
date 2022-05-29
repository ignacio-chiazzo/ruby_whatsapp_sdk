# frozen_string_literal: true

require_relative "data_response"
require_relative "phone_number_data_response"

module Whatsapp
  module Api
    class PhoneNumberDataResponse < DataResponse
      attr_accessor :id, :verified_name, :display_phone_number, :quality_rating

      def initialize(id:, verified_name:, display_phone_number:, quality_rating:)
        @id = id
        @verified_name = verified_name
        @display_phone_number = display_phone_number
        @quality_rating = quality_rating
      end

      def self.build_from_response(response:)
        return unless response["id"]

        Whatsapp::Api::PhoneNumberDataResponse.new(
          id: response.dig("id"),
          verified_name: response.dig("verified_name"),
          display_phone_number: response.dig("display_phone_number"),
          quality_rating: response.dig("quality_rating")
        )
      end
    end
  end
end
