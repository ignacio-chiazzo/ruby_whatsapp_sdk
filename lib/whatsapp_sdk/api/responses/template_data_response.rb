# typed: strict
# frozen_string_literal: true

require_relative "data_response"
require_relative "../../resource/template"

module WhatsappSdk
  module Api
    module Responses
      class TemplateDataResponse < DataResponse
        sig { returns(String) }
        attr_accessor :id

        sig { returns(T.nilable(WhatsappSdk::Resource::Template::Status)) }
        attr_accessor :status

        sig { returns(T.nilable(WhatsappSdk::Resource::Template::Category)) }
        attr_accessor :category

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response)
          @id = T.let(response["id"], String)
          @status = WhatsappSdk::Resource::Template::Status.try_deserialize(response["status"])
          @category = WhatsappSdk::Resource::Template::Category.try_deserialize(response["category"])
          
          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(TemplateDataResponse)) }
        def self.build_from_response(response:)
          return unless response["id"]

          new(response)
        end
      end
    end
  end
end
