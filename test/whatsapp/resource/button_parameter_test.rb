# typed: true
# frozen_string_literal: true

require "test_helper"
require 'resource/button_parameter'

module WhatsappSdk
  module Resource
    module Resource
      class ButtonParameterTest < Minitest::Test
        def test_creates_a_valid_parameter_object_with_a_valid_type
          ButtonParameter.new(type: ButtonParameter::Type::PAYLOAD, payload: "payload")
          ButtonParameter.new(type: ButtonParameter::Type::TEXT, text: "text")
        end

        def test_to_json
          button_parameter_payload = ButtonParameter.new(type: ButtonParameter::Type::PAYLOAD, payload: "payload")
          assert_equal({ type: "payload", payload: "payload" }, button_parameter_payload.to_json)

          button_parameter_test = ButtonParameter.new(
            type: ButtonParameter::Type::TEXT, text: "text"
          )
          assert_equal({ type: "text", text: "text" }, button_parameter_test.to_json)
        end
      end
    end
  end
end
