# frozen_string_literal: true

# 1) Copy this code into a file and save it `example.rb`
# 2) Replace the `ACCESS_TOKEN` constant with a valid `access_token`.
# 3) Run the file with the command `ruby example.rb`

require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "whatsapp_sdk"
  gem "pry"
  gem "pry-nav"
end

require 'whatsapp_sdk'
require "pry"
require "pry-nav"

ACCESS_TOKEN = "foo" # replace this with a valid access_token
SENDER_ID = 123
RECIPIENT_NUMBER = "456"

client = WhatsappSdk::Api::Client.new(ACCESS_TOKEN) # replace this with a valid access_token
messages_api = WhatsappSdk::Api::Messages.new(client)
phone_numbers_api = WhatsappSdk::Api::PhoneNumbers.new(client)

phone_numbers_api.registered_number("123")
phone_numbers_api.registered_numbers("457")

messages_api.send_text(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, message: "hola")
messages_api.send_location(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
  longitude: 45.4215, latitude: 75.6972, name: "nacho", address: "141 cooper street"
)

# Send images

## with a link
messages_api.send_image(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: "image_link", caption: "Ignacio Chiazzo Profile"
)

## with an image id
messages_api.send_image(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, image_id: "1234", caption: "Ignacio Chiazzo Profile"
)

# Send audios
## with a link
messages_api.send_audio(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: "audio_link")

## with an audio id
messages_api.send_audio(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, audio_id: "1234")

# Send documents
## with a link
messages_api.send_document(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: "document_link", caption: "Ignacio Chiazzo"
)

## with a document id
messages_api.send_document(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, document_id: "1234", caption: "Ignacio Chiazzo"
)

# send stickers
## with a link
messages_api.send_sticker(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: "link")

## with a sticker_id
messages_api.send_sticker(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, sticker_id: "1234")

# Send a template.
# Note: The template must have been created previously.

header_component = WhatsappSdk::Resource::Component.new(
  type: WhatsappSdk::Resource::Component::Type::HEADER
)

image = WhatsappSdk::Resource::Media.new(type: "image", link: "http(s)://URL", caption: "caption")
document = WhatsappSdk::Resource::Media.new(type: "document", link: "http(s)://URL", filename: "txt.rb")
video = WhatsappSdk::Resource::Media.new(type: "video", id: 123)

parameter_image = WhatsappSdk::Resource::ParameterObject.new(
  type: "image",
  image: image
)

parameter_document = WhatsappSdk::Resource::ParameterObject.new(
  type: "document",
  document: document
)

parameter_video = WhatsappSdk::Resource::ParameterObject.new(
  type: "video",
  video: video
)

parameter_text = WhatsappSdk::Resource::ParameterObject.new(
  type: "text",
  text: "I am a text"
)

header_component.add_parameter(parameter_text)
header_component.add_parameter(parameter_image)
header_component.add_parameter(parameter_video)
header_component.add_parameter(parameter_document)
header_component.to_json

body_component = WhatsappSdk::Resource::Component.new(
  type: WhatsappSdk::Resource::Component::Type::BODY
)
body_component.add_parameter(parameter_text)
body_component.add_parameter(parameter_image)
body_component.add_parameter(parameter_video)
body_component.add_parameter(parameter_document)
body_component.to_json

button_component_1 = WhatsappSdk::Resource::Component.new(
  type: WhatsappSdk::Resource::Component::Type::BUTTON,
  index: 0,
  sub_type: WhatsappSdk::Resource::Component::Subtype::QUICK_REPLY,
  parameters: [WhatsappSdk::Resource::ButtonParameter.new(type: "payload", payload: "payload")]
)

button_component_2 = WhatsappSdk::Resource::Component.new(
  type: WhatsappSdk::Resource::Component::Type::BUTTON,
  index: 1,
  sub_type: WhatsappSdk::Resource::Component::Subtype::QUICK_REPLY,
  parameters: [WhatsappSdk::Resource::ButtonParameter.new(type: "payload", payload: "payload")]
)

# make sure that the template was created
response_with_json = messages_api.send_template(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, name: "hello_world", language: "en_US",
  components_json: [
    {
      "type": "header",
      "parameters": [
        {
          "type": "image",
          "image": {
            "link": "https://www.google.com/imgres?imgurl=https%3A%2F%2Fqph.cf2.quoracdn.net%2Fmain-qimg-6d977408fdd90a09a1fee7ba9e2f777c-lq&imgrefurl=https%3A%2F%2Fwww.quora.com%2FHow-can-I-find-my-WhatsApp-ID&tbnid=lDAx1vzXwqCakM&vet=12ahUKEwjKupLviJX4AhVrrHIEHQpGD9MQMygAegUIARC9AQ..i&docid=s-DNQVCrZmhJYM&w=602&h=339&q=example%20whatsapp%20image%20id&ved=2ahUKEwjKupLviJX4AhVrrHIEHQpGD9MQMygAegUIARC9AQ"
          }
        }
      ]
    }
  ]
)
puts response_with_json

response_with_object = messages_api.send_template(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, name: "hello_world", language: "en_US",
  components: [header_component, body_component, button_component_1, button_component_2]
)
puts response_with_object
