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

################# UPDATE CONSTANTS #################

ACCESS_TOKEN = "<TODO replace>"
SENDER_ID = "<TODO replace>"
RECIPIENT_NUMBER = "<TODO replace>"
BUSINESS_ID = "<TODO replace>"
IMAGE_LINK = "<TODO replace>"

################# Initialize Client #################
WhatsappSdk.configure do |config|
  config.access_token = ACCESS_TOKEN
end

################# HELPERS ########################
def print_message_sent(message_response)
  if message_response.ok?
    puts "Message sent to: #{message_response.data.contacts.first.input}"
  else
    puts "Error: #{message_response.error&.to_s}"
  end
end
##################################################

medias_api = WhatsappSdk::Api::Medias.new
messages_api = WhatsappSdk::Api::Messages.new
phone_numbers_api = WhatsappSdk::Api::PhoneNumbers.new

############################## Phone Numbers API ##############################
phone_numbers_api.registered_number(SENDER_ID)
phone_numbers_api.registered_numbers(BUSINESS_ID)
############################## Media API ##############################

# upload a media
uploaded_media = medias_api.upload(sender_id: SENDER_ID, file_path: "tmp/whatsapp.png", type: "image/png")
puts "Uploaded media id: #{uploaded_media.data&.id}"

# get a media
media = medias_api.media(media_id: uploaded_media.data&.id).data
puts "Media info: #{media.raw_data_response}"

# download media
download_image = medias_api.download(url: media&.url, file_path: 'tmp/downloaded_whatsapp.png')
puts "Downloaded: #{download_image.data.success?}"

# delete a media
deleted_media = medias_api.delete(media_id: media&.id)
puts "Deleted: #{deleted_media.data.success?}"

############################## Messages API ##############################

######### SEND A TEXT MESSAGE
message_sent = messages_api.send_text(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
                                      message: "Hey there! it's Whatsapp Ruby SDK")
print_message_sent(message_sent)

location_sent = messages_api.send_location(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
  longitude: -75.6898604, latitude: 45.4192206, name: "Ignacio", address: "My house"
)
print_message_sent(location_sent)

######### READ A MESSAGE
# messages_api.read_message(sender_id: SENDER_ID, message_id: msg_id)

######### SEND AN IMAGE
# Send an image with a link
image_sent = messages_api.send_image(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: media.url, caption: "Ignacio Chiazzo Profile"
)
print_message_sent(image_sent)

# Send an image with an id
messages_api.send_image(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, image_id: media.id, caption: "Ignacio Chiazzo Profile"
)

######### SEND AUDIOS
## with a link
messages_api.send_audio(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: "audio_link")

## with an audio id
messages_api.send_audio(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, audio_id: "1234")

######### SEND DOCUMENTS
## with a link
messages_api.send_document(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: "document_link", caption: "Ignacio Chiazzo"
)

## with a document id
messages_api.send_document(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, document_id: "1234", caption: "Ignacio Chiazzo"
)

######### SEND STICKERS
## with a link
messages_api.send_sticker(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: "link")

## with a sticker_id
messages_api.send_sticker(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, sticker_id: "1234")

######### SEND A TEMPLATE
# Note: The template must have been created previously.

# Send a template with no component
response_with_object = messages_api.send_template(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
                                                  name: "hello_world", language: "en_US", components: [])
puts response_with_object

# Send a template with components.Remember to create the template first.
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

# button_component_1 = WhatsappSdk::Resource::Component.new(
#   type: WhatsappSdk::Resource::Component::Type::BUTTON,
#   index: 0,
#   sub_type: WhatsappSdk::Resource::Component::Subtype::QUICK_REPLY,
#   parameters: [WhatsappSdk::Resource::ButtonParameter.new(type: "payload", payload: "payload")]
# )

# button_component_2 = WhatsappSdk::Resource::Component.new(
#   type: WhatsappSdk::Resource::Component::Type::BUTTON,
#   index: 1,
#   sub_type: WhatsappSdk::Resource::Component::Subtype::QUICK_REPLY,
#   parameters: [WhatsappSdk::Resource::ButtonParameter.new(type: "payload", payload: "payload")]
# )

# Send a template with component_json
response_with_json = messages_api.send_template(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, name: "hello_world", language: "en_US",
  components_json: [
    {
      "type" => "header",
      "parameters" => [
        {
          "type" => "image",
          "image" => {
            "link" => "https://www.google.com/imgres?imgurl=https%3A%2F%2Fqph.cf2.quoracdn.net%2Fmain-qimg-6d977408fdd90a09a1fee7ba9e2f777c-lq&imgrefurl=https%3A%2F%2Fwww.quora.com%2FHow-can-I-find-my-WhatsApp-ID&tbnid=lDAx1vzXwqCakM&vet=12ahUKEwjKupLviJX4AhVrrHIEHQpGD9MQMygAegUIARC9AQ..i&docid=s-DNQVCrZmhJYM&w=602&h=339&q=example%20whatsapp%20image%20id&ved=2ahUKEwjKupLviJX4AhVrrHIEHQpGD9MQMygAegUIARC9AQ"
          }
        }
      ]
    }
  ]
)
puts response_with_json
