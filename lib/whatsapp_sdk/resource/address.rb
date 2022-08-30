# frozen_string_literal: true
# typed: true

module WhatsappSdk
  module Resource
    class Address
      attr_accessor :street, :city, :state, :zip, :country, :country_code, :typ

      module AddressType
        HOME = "HOME"
        WORK = "WORK"
      end

      def initialize(street:, city:, state:, zip:, country:, country_code:, type: AddressType::HOME)
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
