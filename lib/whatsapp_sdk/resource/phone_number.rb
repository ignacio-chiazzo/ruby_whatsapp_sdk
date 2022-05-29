# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class PhoneNumber
      attr_accessor :phone, :type, :wa_id

      PHONE_NUMBER_TYPE = {
        home: "HOME",
        work: "WORK"
      }.freeze

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
