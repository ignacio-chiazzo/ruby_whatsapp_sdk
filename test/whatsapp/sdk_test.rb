require "test_helper"

class WhatsappTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Whatsapp::VERSION
  end
end
