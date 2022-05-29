# frozen_string_literal: true

# Version
require_relative "whatsapp"

# APIs
require_relative "whatsapp/api/phone_numbers"
require_relative "whatsapp/api/messages"
require_relative "whatsapp/api/client"

# APIs responses
require_relative "whatsapp/api/responses/message_data_response"
require_relative "whatsapp/api/responses/phone_number_data_response"
require_relative "whatsapp/api/responses/phone_numbers_data_response"
require_relative "whatsapp/api/responses/error_response"
require_relative "whatsapp/api/responses/data_response"

# Resources
require_relative "whatsapp/resource/address"
require_relative "whatsapp/resource/contact_response"
require_relative "whatsapp/resource/contact"
require_relative "whatsapp/resource/email"
require_relative "whatsapp/resource/message"
require_relative "whatsapp/resource/name"
require_relative "whatsapp/resource/org"
require_relative "whatsapp/resource/phone_number"
require_relative "whatsapp/resource/url"

module WhatsappSdk
  VERSION = "0.0.1"
end
  