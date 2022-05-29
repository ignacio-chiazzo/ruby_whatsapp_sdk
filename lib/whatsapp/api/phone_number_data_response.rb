# frozen_string_literal: true

require_relative "data_response"

module Whatsapp
  module Api
    class PhoneNumberDataResponse < DataResponse
      attr_accessor :id, :verified_name, :display_phone_number, :quality_rating

      def initialize(response)
        @id = response["id"]
        @verified_name = response["verified_name"]
        @display_phone_number = response["display_phone_number"]
        @quality_rating = response["quality_rating"]
        super(response)
      end

      def self.build_from_response(response:)
        return unless response["id"]

        Whatsapp::Api::PhoneNumberDataResponse.new(response)
      end
    end
  end
end
