# typed: strict
# frozen_string_literal: true

require_relative "data_response"
require_relative "../../resource/template"

module WhatsappSdk
  module Api
    module Responses
      class TemplateDataResponse < DataResponse
        sig { returns(::WhatsappSdk::Resource::Template) }
        attr_reader :template

        sig { params(response: T::Hash[T.untyped, T.untyped]).void }
        def initialize(response:)
          @template = parse_template(response)

          super(response)
        end

        sig { override.params(response: T::Hash[T.untyped, T.untyped]).returns(T.nilable(TemplateDataResponse)) }
        def self.build_from_response(response:)
          return unless response["id"]

          new(response: response)
        end

        private

        sig { params(template_json: T::Hash[T.untyped, T.untyped]).returns(::WhatsappSdk::Resource::Template) }
        def parse_template(template_json)
          status = ::WhatsappSdk::Resource::Template::Status.try_deserialize(template_json["status"])
          category = ::WhatsappSdk::Resource::Template::Category.try_deserialize(template_json["category"])

          ::WhatsappSdk::Resource::Template.new(id: template_json["id"], status: status, category: category)
        end
      end
    end
  end
end
