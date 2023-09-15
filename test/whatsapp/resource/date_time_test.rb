# typed: true
# frozen_string_literal: true

require "test_helper"
require 'whatsapp_sdk/resource/date_time'

module WhatsappSdk
  module Resource
    module Resource
      class DateTimeTest < Minitest::Test
        def test_to_json
          date_time = WhatsappSdk::Resource::DateTime.new(fallback_value: "2020-01-01T00:00:00Z")
          assert_equal({ fallback_value: "2020-01-01T00:00:00Z" }, date_time.to_json)
        end
      end
    end
  end
end
