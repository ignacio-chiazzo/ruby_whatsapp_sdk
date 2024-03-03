# typed: true
# frozen_string_literal: true

require "test_helper"
require 'version'

class VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    assert_equal("0.12.0", WhatsappSdk::VERSION)
  end
end
