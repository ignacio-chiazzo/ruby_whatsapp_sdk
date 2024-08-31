
# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Email
      attr_accessor :email, :type

      def initialize(email:, type:)
        @email = email
        @type = type
      end

      def to_h
        {
          email: @email,
          type: @type
        }
      end
    end
  end
end
