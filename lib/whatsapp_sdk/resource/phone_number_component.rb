# frozen_string_literal: true

# The media used by a component (button, header, body, footer) etc.

module WhatsappSdk
  module Resource
    class PhoneNumberComponent
      attr_accessor :phone, :wa_id, :type

      def initialize(phone:, type:, wa_id:)
        @phone = phone
        @type = type
        @wa_id = wa_id
      end

      def to_h
        {
          phone: @phone,
          type: @type,
          wa_id: @wa_id
        }
      end
    end
  end
end
