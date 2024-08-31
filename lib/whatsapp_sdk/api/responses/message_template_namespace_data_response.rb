# frozen_string_literal: true

require_relative "data_response"
require_relative "../../resource/template"

module WhatsappSdk
  module Api
    module Responses
      class MessageTemplateNamespaceDataResponse < DataResponse
        attr_accessor :message_template_namespace, :id

        def initialize(response)
          @id = response["id"]
          @message_template_namespace = response["message_template_namespace"]

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
