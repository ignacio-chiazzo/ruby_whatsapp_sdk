# frozen_string_literal: true

require_relative "data_response"
require_relative "template_data_response"

module WhatsappSdk
  module Api
    module Responses
      class TemplatesDataResponse < DataResponse
        attr_reader :templates

        def initialize(response)
          @templates = response['data']&.map { |template| parse_templates(template) }

          super(response)
        end

        def self.build_from_response(response:)
          return unless response["data"]

          new(response)
        end

        private

        def parse_templates(template)
          TemplateDataResponse.new(response: template)
        end
      end
    end
  end
end
