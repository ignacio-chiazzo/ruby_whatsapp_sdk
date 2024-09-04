# frozen_string_literal: true

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class BusinessProfileDataResponse < DataResponse
        attr_accessor :about, :address, :description, :email, :messaging_product,
                      :profile_picture_url, :vertical, :websites

        def initialize(response)
          @about = response["data"][0]["about"]
          @address = response["data"][0]["address"]
          @description = response["data"][0]["description"]
          @email = response["data"][0]["email"]
          @messaging_product = response["data"][0]["messaging_product"]
          @profile_picture_url = response["data"][0]["profile_picture_url"]
          @vertical = response["data"][0]["vertical"]
          @websites = response["data"][0]["websites"]

          super(response)
        end

        def self.build_from_response(response:)
          return nil if response['error']

          new(response)
        end
      end
    end
  end
end
