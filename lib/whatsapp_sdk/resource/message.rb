# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class Message
      attr_reader :id

      # @return [String, nil] Message acceptance/pacing status, only when returned by Meta.
      attr_reader :message_status

      def initialize(id:, message_status: nil)
        @id = id
        @message_status = message_status
      end
    end
  end
end
