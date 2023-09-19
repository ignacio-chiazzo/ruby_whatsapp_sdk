# typed: strict
# frozen_string_literal: true

require_relative "data_response"
require_relative "../../resource/template"

module WhatsappSdk
  module Api
    module Responses
      class TemplatesDataResponse < DataResponse
        sig { returns(T::Array[Resource::Template]) }
        attr_reader :templates

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response:)
          @templates = response['data']&.map { |template| parse_template(template) }

          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(TemplatesDataResponse)) }
        def self.build_from_response(response:)
          return unless response["data"]

          new(response: response)
        end

        private

        sig { params(template_json: T::Hash[T.untyped, T.untyped]).returns(::WhatsappSdk::Resource::Template) }
        def parse_template(template_json)
          status = Resource::Template::Status.try_deserialize(template_json["status"])
          category = Resource::Template::Category.try_deserialize(template_json["category"])

          Resource::Template.new(
            id: template_json["id"], status: status, category: category,
            name: template_json["name"] || "",
            language: template_json["language"] || "en_US",
            components: template_json["components"] || [] # TODO: Parse components
          )
        end
      end
    end
  end
end
