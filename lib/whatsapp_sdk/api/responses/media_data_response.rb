# frozen_string_literal: true

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class MediaDataResponse < DataResponse
        attr_accessor :id, :url, :mime_type, :sha256, :file_size, :messaging_product

        def initialize(response)
          @id = response["id"]
          @messaging_product = response["messaging_product"]
          @url = response["url"]
          @mime_type = response["mime_type"]
          @sha256 = response["sha256"]
          @file_size = response["file_size"]
          super(response)
        end

        def self.build_from_response(response:)
          return unless response["id"]

          new(response)
        end
      end
    end
  end
end
