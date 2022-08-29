# frozen_string_literal: true
# typed: true

require "test_helper"
require "version"

class VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::WhatsappSdk::VERSION
  end
end
