# frozen_string_literal: true

# APIs
require_relative "whatsapp_sdk/api/phone_numbers"
require_relative "whatsapp_sdk/api/messages"
require_relative "whatsapp_sdk/api/client"

# APIs responses
require_relative "whatsapp_sdk/api/responses/message_data_response"
require_relative "whatsapp_sdk/api/responses/phone_number_data_response"
require_relative "whatsapp_sdk/api/responses/phone_numbers_data_response"
require_relative "whatsapp_sdk/api/responses/error_response"
require_relative "whatsapp_sdk/api/responses/data_response"

# Resources
require_relative "whatsapp_sdk/resource/address"
require_relative "whatsapp_sdk/resource/contact_response"
require_relative "whatsapp_sdk/resource/contact"
require_relative "whatsapp_sdk/resource/email"
require_relative "whatsapp_sdk/resource/message"
require_relative "whatsapp_sdk/resource/name"
require_relative "whatsapp_sdk/resource/org"
require_relative "whatsapp_sdk/resource/phone_number"
require_relative "whatsapp_sdk/resource/url"
