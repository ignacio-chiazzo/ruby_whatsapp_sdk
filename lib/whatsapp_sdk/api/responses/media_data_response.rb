# typed: strict
# frozen_string_literal: true

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

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response)
          @id = T.let(response["id"], String)
          @messaging_product = T.let(response["messaging_product"], T.nilable(String))
          @url = T.let(response["url"], T.nilable(String))
          @mime_type = T.let(response["mime_type"], T.nilable(String))
          @sha256 = T.let(response["sha256"], T.nilable(String))
          @file_size = T.let(response["file_size"], T.nilable(Integer))
          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(MediaDataResponse)) }
        def self.build_from_response(response:)
          return unless response["id"]

          new(response)
        end
      end
    end
  end
end
