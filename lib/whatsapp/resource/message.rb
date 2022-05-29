# frozen_string_literal: true

module Whatsapp
  module Resource
    class Message
      attr_reader :id

      def initialize(id:)
        @id = id
      end
    end
  end
end
