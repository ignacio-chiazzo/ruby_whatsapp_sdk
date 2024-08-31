# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Address
      attr_accessor :street, :city, :state, :zip, :country, :country_code, :type

      def initialize(street:, city:, state:, zip:, country:, country_code:, type: AddressType::Home)
        @street = street
        @city = city
        @state = state
        @zip = zip
        @country = country
        @country_code = country_code
        @type = type
      end

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
