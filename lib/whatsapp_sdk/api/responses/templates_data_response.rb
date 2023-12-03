# typed: strict
# frozen_string_literal: true

require_relative "data_response"
require_relative "template_data_response"

module WhatsappSdk
  module Api
    module Responses
      class TemplatesDataResponse < DataResponse
        sig { returns(T::Array[TemplateDataResponse]) }
        attr_reader :templates

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response)
          @templates = T.let(
            response['data']&.map { |template| parse_templates(template) },
            T::Array[TemplateDataResponse]
          )
          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(TemplatesDataResponse)) }
        def self.build_from_response(response:)
          return unless response["data"]

          new(response)
        end

        private

        sig { params(template: T::Hash[T.untyped, T.untyped]).returns(TemplateDataResponse) }
        def parse_templates(template)
          TemplateDataResponse.new(response: template)
        end
      end
    end
  end
end
