module Whatsapp
  module Resource
    class PhoneNumberResponse
      attr_accessor :id, :verified_name, :display_phone_number, :quality_rating

      def initialize(id:, verified_name:, display_phone_number:, quality_rating:)
        @id = id
        @verified_name = verified_name
        @display_phone_number = display_phone_number
        @quality_rating = quality_rating
      end
    end
  end
end
