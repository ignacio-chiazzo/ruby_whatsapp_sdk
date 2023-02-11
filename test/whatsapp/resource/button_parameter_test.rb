# typed: true
# frozen_string_literal: true

require "test_helper"
require_relative '../../../lib/whatsapp_sdk/resource/button_parameter'

module WhatsappSdk
  module Resource
    module Resource
      class ButtonParameterTest < Minitest::Test
        def test_creates_a_valid_parameter_object_with_a_valid_type
          WhatsappSdk::Resource::ButtonParameter.new(
            type: WhatsappSdk::Resource::ButtonParameter::Type::Payload, payload: "payload"
          )
          WhatsappSdk::Resource::ButtonParameter.new(
            type: WhatsappSdk::Resource::ButtonParameter::Type::Text, text: "text"
          )
        end

        def test_to_json
          button_parameter_payload = WhatsappSdk::Resource::ButtonParameter.new(
            type: WhatsappSdk::Resource::ButtonParameter::Type::Payload, payload: "payload"
          )
          assert_equal({ type: "payload", payload: "payload" }, button_parameter_payload.to_json)

          button_parameter_test = WhatsappSdk::Resource::ButtonParameter.new(
            type: WhatsappSdk::Resource::ButtonParameter::Type::Text, text: "text"
          )
          assert_equal({ type: "text", text: "text" }, button_parameter_test.to_json)
        end
      end
    end
  end
end
