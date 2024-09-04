# frozen_string_literal: true

require_relative "data_response"
require_relative "../../resource/template"

module WhatsappSdk
  module Api
    module Responses
      class TemplateDataResponse < DataResponse
        attr_reader :template

        def initialize(response:)
          @template = parse_template(response)

          super(response)
        end

        def self.build_from_response(response:)
          return unless response["id"]

          new(response: response)
        end

        private

        def parse_template(template_json)
          status = template_json["status"]
          category = template_json["category"]
          id = template_json["id"]
          language = template_json["language"]
          name = template_json["name"]
          components_json = template_json["components"]

          ::WhatsappSdk::Resource::Template.new(
            id: id,
            status: status,
            category: category,
            language: language,
            name: name,
            components_json: components_json
          )
        end
      end
    end
  end
end
