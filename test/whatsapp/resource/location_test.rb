# typed: true
# frozen_string_literal: true

require "test_helper"
require "resource/location"

module WhatsappSdk
  module Resource
    module Resource
      class LocationTest < Minitest::Test
        def test_to_json
          location = Location.new(latitude: 25.779510, longitude: -80.338631, name: "Miami Store",
                                  address: "820 NW 87th Ave, Miami, FL")
          assert_equal(
            { latitude: 25.779510, longitude: -80.338631, name: "Miami Store",
              address: "820 NW 87th Ave, Miami, FL" }, location.to_json
          )
        end
      end
    end
  end
end
