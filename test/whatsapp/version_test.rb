# frozen_string_literal: true
# typed: true

require "test_helper"
require_relative '../../lib/whatsapp_sdk/version'

class VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    assert_equal("0.7.0", WhatsappSdk::VERSION)
  end
end
