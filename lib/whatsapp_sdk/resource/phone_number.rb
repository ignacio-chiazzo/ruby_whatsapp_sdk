# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class PhoneNumber
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
