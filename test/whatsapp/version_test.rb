# typed: true
# frozen_string_literal: true

require "test_helper"
require_relative '../../lib/whatsapp_sdk/version'

class VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    assert_equal("0.9.2", WhatsappSdk::VERSION)
  end
end
