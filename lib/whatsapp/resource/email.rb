# frozen_string_literal: true

module Whatsapp
  module Resource
    class Email
      attr_accessor :email, :type

      EMAIL_TYPE = {
        home: "HOME",
        work: "WORK"
      }.freeze

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
