# typed: strict
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Address
      extend T::Sig

      sig { returns(String) }
      attr_accessor :street

      sig { returns(String) }
      attr_accessor :city

      sig { returns(String) }
      attr_accessor :state

      sig { returns(String) }
      attr_accessor :zip

      sig { returns(String) }
      attr_accessor :country

      sig { returns(String) }
      attr_accessor :country_code

      sig { returns(AddressType) }
      attr_accessor :type

      sig do
        params(
          street: String, city: String, state: String, zip: String,
          country: String, country_code: String, type: AddressType
        ).void
      end
      def initialize(street:, city:, state:, zip:, country:, country_code:, type: AddressType::Home)
        @street = street
        @city = city
        @state = state
        @zip = zip
        @country = country
        @country_code = country_code
        @type = type
      end

      sig { returns(T::Hash[T.untyped, T.untyped]) }
      def to_h
        {
          street: @street,
          city: @city,
          state: @state,
          zip: @zip,
          country: @country,
          country_code: @country_code,
          type: @type
        }
      end
    end
  end
end
