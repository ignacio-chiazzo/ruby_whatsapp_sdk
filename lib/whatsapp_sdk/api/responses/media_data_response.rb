# frozen_string_literal: true
# typed: true

require_relative "data_response"

module WhatsappSdk
  module Api
    module Responses
      class MediaDataResponse < DataResponse
        sig { returns(String) }
        attr_accessor :id

        sig { returns(T.nilable(String)) }
        attr_accessor :url

        sig { returns(T.nilable(String)) }
        attr_accessor :mime_type

        sig { returns(T.nilable(String)) }
        attr_accessor :sha256

        sig { returns(T.nilable(Integer)) }
        attr_accessor :file_size

        sig { returns(T.nilable(String)) }
        attr_accessor :messaging_product

        sig { params(response: Hash).void }
        def initialize(response)
          @id = response["id"]
          @messaging_product = response["messaging_product"]
          @url = response["url"]
          @mime_type = response["mime_type"]
          @sha256 = response["sha256"]
          @file_size = response["file_size"]
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
