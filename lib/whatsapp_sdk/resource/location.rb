# typed: false
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Location
      # Returns the latitude of the location.
      #
      # @returns latitude [Float].
      attr_accessor :latitude

      # Returns the longitude of the location.
      #
      # @returns longitude [Float].
      attr_accessor :longitude

      # Returns the name of the location.
      #
      # @returns name [String].
      attr_accessor :name

      # Returns the address of the location.
      #
      # @returns address [String].
      attr_accessor :address

      def initialize(latitude:, longitude:, name:, address:)
        @latitude = latitude
        @longitude = longitude
        @name = name
        @address = address
      end

      def to_json
        {
          latitude: latitude,
          longitude: longitude,
          name: name,
          address: address
        }
      end
    end
  end
end
