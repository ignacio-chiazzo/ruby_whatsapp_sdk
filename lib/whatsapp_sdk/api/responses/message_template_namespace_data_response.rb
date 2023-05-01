# typed: strict
# frozen_string_literal: true

require_relative "data_response"
require_relative "../../resource/template"

module WhatsappSdk
  module Api
    module Responses
      class MessageTemplateNamespaceDataResponse < DataResponse
        sig { returns(String) }
        attr_accessor :message_template_namespace

        sig { returns(String) }
        attr_accessor :id

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response)
          @id = T.let(response["id"], String)
          @message_template_namespace = T.let(response["message_template_namespace"], String)
          
          super(response)
        end

        sig do 
          override.params(response: T::Hash[T.untyped, T.untyped])
          .returns(T.nilable(MessageTemplateNamespaceDataResponse))
        end
        def self.build_from_response(response:)
          return unless response["id"]

          new(response)
        end
      end
    end
  end
end
