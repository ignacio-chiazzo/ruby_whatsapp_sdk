# frozen_string_literal: true

module WhatsappSdk
  module Resource
    class MessageTemplateNamespace
      attr_accessor :id, :message_template_namespace

      def self.from_hash(hash)
        message_template_namespace = new
        message_template_namespace.id = hash["id"]
        message_template_namespace.message_template_namespace = hash["message_template_namespace"]

        message_template_namespace
      end
    end
  end
end
