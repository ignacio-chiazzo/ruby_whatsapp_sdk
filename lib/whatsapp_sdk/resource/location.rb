module WhatsappSdk
  module Resource
    class Location
      extend T::Sig

      # Returns the latitude of the location.
      #
      # @returns latitude [Float].
      sig { returns(T.nilable(Float)) }
      attr_accessor :latitude

      # Returns the longitude of the location.
      #
      # @returns longitude [Float].
      sig { returns(T.nilable(Float)) }
      attr_accessor :longitude

      # Returns the name of the location.
      #
      # @returns name [String].
      sig { returns(T.nilable(String)) }
      attr_accessor :name

      # Returns the address of the location.
      #
      # @returns address [String].
      sig { returns(T.nilable(String)) }
      attr_accessor :address

      sig { params(latitude: Float, longitude: Float, name: String, address: String).void }
      def initialize(latitude:, longitude:, name:, address:)
        @latitude = latitude
        @longitude = longitude
        @name = name
        @address = address
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
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