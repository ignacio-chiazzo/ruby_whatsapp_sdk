# frozen_string_literal: true

# 1) Copy this code into a file and save it `example.rb`
# 2) Replace the `ACCESS_TOKEN` constant with a valid `access_token`.
# 3) Run the file with the command `ruby example.rb`

require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "whatsapp_sdk", path: "../"
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

if ACCESS_TOKEN == "<TODO replace>"
  puts "\n\n**** Please update the ACCESS_TOKEN constant in this file. ****\n\n"
  exit
end

puts "\n\n\n\ ------------------ Starting calling the Cloud API -------------------\n"

################# Initialize Client #################
WhatsappSdk.configure do |config|
  config.access_token = ACCESS_TOKEN
end

################# HELPERS ########################
def print_message_sent(message_response, type = "")
  if message_response.ok?
    puts "Message #{type} sent to: #{message_response.data.contacts.first.input}"
  else
    puts "Error: #{message_response.error.message}"
  end
end

def print_data_or_error(response, identifier)
  if response.error?
    return "Error: #{response.error&.to_s}"
  end

  return identifier
end
##################################################
client = WhatsappSdk::Api::Client.new



############################## Templates API ##############################
puts "\n\n ------------------ Testing Templates API ------------------------"

## Get list of templates
templates = client.templates.list(business_id: BUSINESS_ID)
puts "GET Templates list : #{print_data_or_error(templates, templates.data&.templates.map { |r| r.template.name })}"

## Get message templates namespace
template_namespace = client.templates.get_message_template_namespace(business_id: BUSINESS_ID)
puts "GET template by namespace: #{print_data_or_error(template_namespace, template_namespace.data&.id)}"

# Create a template
components_json = [
  {
    "type": "BODY",
    "text": "Thank you for your order, {{1}}! Your confirmation number is {{2}}. If you have any questions, please use the buttons below to contact support. Thank you for being a customer!",
    "example": {
      "body_text": [
        [
          "Ignacio","860198-230332"
        ]
      ]
    }
  },
  {
    "type": "BUTTONS",
    "buttons": [
      {
        "type": "PHONE_NUMBER",
        "text": "Call",
        "phone_number": "59898400766"
      },
      {
        "type": "URL",
        "text": "Contact Support",
        "url": "https://www.luckyshrub.com/support"
      }
    ]
  }
]

new_template = client.templates.create(
  business_id: BUSINESS_ID, name: "seasonal_promotion", language: "ka", category: "MARKETING",
  components_json: components_json, allow_category_change: true
)
puts "GET template by namespace: #{print_data_or_error(template_namespace, template_namespace.data&.id)}"

# Update a template
components_json = [
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

if new_template&.data&.id
  updated_template = client.templates.update(template_id: new_template&.data.id, category: "UTILITY")
  puts "UPDATE template by id: #{print_data_or_error(updated_template, updated_template.data&.id)}"
end

## Delete a template
delete_template = client.templates.delete(business_id: BUSINESS_ID, name: "seasonal_promotion") # delete by name
puts "Delete template by id: #{print_data_or_error(delete_template, delete_template.data&.id) }"

# client.templates.delete(business_id: BUSINESS_ID, name: "name2", hsm_id: "243213188351928") # delete by name and id



############################## Business API ##############################
puts "\n\n\n ------------------ Testing Business API -----------------------"

business_profile = client.business_profiles.get(SENDER_ID)
puts "DELETE Business Profile by id: #{print_data_or_error(delete_template, business_profile.data&.about) }"

updated_bp = client.business_profiles.update(phone_number_id: SENDER_ID, params: { about: "A very cool business" } )
puts "UPDATE Business Profile by id: #{print_data_or_error(updated_bp, updated_bp.data&.success?) }"


############################## Phone Numbers API ##############################
puts "\n\n\n ------------------ Testing Phone Numbers API -----------------------"
registered_number = client.phone_numbers.get(SENDER_ID)
puts "GET Registered number: #{print_data_or_error(registered_number, registered_number.data&.id)}"

registered_numbers = client.phone_numbers.list(BUSINESS_ID)
puts "GET Registered numbers: #{print_data_or_error(registered_number, registered_numbers.data&.phone_numbers.map(&:id))}"

############################## Media API ##############################
puts "\n\n\n ------------------ Testing Media API"
##### Image #####
# upload a Image
uploaded_media = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/whatsapp.png", type: "image/png")
puts "Uploaded image id: #{print_data_or_error(uploaded_media, uploaded_media.data&.id)}"

# get a media Image
if uploaded_media.data&.id
  image = client.media.get(media_id: uploaded_media.data&.id)
  puts "GET image id: #{print_data_or_error(image, image.data&.id)}"

  # download media Image
  download_image = client.media.download(url: image.data.url, file_path: 'test/fixtures/assets/downloaded_image.png', media_type: "image/png")
  puts "Downloaded Image: #{print_data_or_error(download_image, download_image.data.success?)}"

  uploaded_media = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/whatsapp.png", type: "image/png")
  # delete a media
  deleted_media = client.media.delete(media_id: uploaded_media.data.id)
  puts "Delete image: #{print_data_or_error(deleted_media, deleted_media.data.success?)}"
else
  puts "No media to download and delete"
end

#### Video ####
# upload a video
uploaded_video = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/riquelme.mp4", type: "video/mp4")
puts "Uploaded video: #{print_data_or_error(uploaded_media, uploaded_video.data&.id)}"

video = client.media.get(media_id: uploaded_video.data&.id)

# upload a video
uploaded_video = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/riquelme.mp4", type: "video/mp4")
puts "Uploaded video id: #{print_data_or_error(uploaded_media, video.data&.id)}"

#### Audio ####
# upload an audio
audio_response = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/downloaded_audio.ogg", type: "audio/ogg")
puts "Uploaded audio id: #{print_data_or_error(audio_response, audio_response.data&.id)}"

if audio_response.data&.id
  audio_id = audio_response.data&.id
  # get a media audio
  audio = client.media.get(media_id: audio_id)
  puts "GET Audio id: #{print_data_or_error(audio, audio_id)}"

  # get a media audio
  audio_link = audio.data.url
  download_image = client.media.download(url: audio_link, file_path: 'test/fixtures/assets/downloaded_audio2.ogg', media_type: "audio/ogg")
  puts "Download Audio: #{print_data_or_error(download_image, download_image.data.success?)}"
end

# upload a document
document_response = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/document.pdf", type: "application/pdf")
puts "Uploaded document id: #{print_data_or_error(document_response, document_response.data&.id)}"

document = client.media.get(media_id: document_response.data&.id)
puts "GET document id: #{print_data_or_error(document, document.data&.id)}"

# upload a sticker
sticker_response = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/sticker.webp", type: "image/webp")
puts "Uploaded sticker id: #{print_data_or_error(sticker_response, sticker_response.data&.id)}"

sticker = client.media.get(media_id: sticker_response.data&.id)
puts "GET Sticker id: #{print_data_or_error(sticker, sticker.data&.id)}"



############################## Messages API ##############################
puts "\n\n\n ------------------ Testing Messages API -----------------------"

######### SEND A TEXT MESSAGE
message_sent = client.messages.send_text(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
                                      message: "Hey there! it's Whatsapp Ruby SDK")
print_message_sent(message_sent, "text")

######### React to a message
message_id = message_sent.data&.messages.first.id
reaction_1_sent = client.messages.send_reaction(
  sender_id: SENDER_ID,
  recipient_number: RECIPIENT_NUMBER,
  message_id: message_id,
  emoji: "\u{1f550}"
) if message_id

reaction_2_sent = client.messages.send_reaction(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
                                             message_id: message_id, emoji: "⛄️") if message_id
puts "Message Reaction 1: #{print_data_or_error(reaction_1_sent, reaction_1_sent.data&.messages.first&.id)}"
puts "Message Reaction 2: #{print_data_or_error(reaction_2_sent, reaction_2_sent.data&.messages.first&.id)}"

######### Reply to a message
message_to_reply_id = message_sent.data.messages.first.id
reply = client.messages.send_text(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, message: "I'm a reply",
                               message_id: message_to_reply_id)
print_message_sent(reply, "reply")

######### Send location

location_sent = client.messages.send_location(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
  longitude: -75.6898604, latitude: 45.4192206, name: "Ignacio", address: "My house"
)
print_message_sent(location_sent, "location")

######### READ A MESSAGE
# client.messages.read_message(sender_id: SENDER_ID, message_id: msg_id)

######### SEND AN IMAGE
# Send an image with a link
if image.data&.id
  image_sent = client.messages.send_image(
    sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: image.data.url, caption: "Ignacio Chiazzo Profile"
  )
  print_message_sent(image_sent, "image via url")

  # Send an image with an id
  client.messages.send_image(
    sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, image_id: image.data.id, caption: "Ignacio Chiazzo Profile"
  )
  print_message_sent(image_sent, "image via id")
end

######### SEND AUDIOS
## with a link
audio_sent = client.messages.send_audio(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: audio.data.url)
print_message_sent(audio_sent, "audio via url")

## with an audio id
audio_sent = client.messages.send_audio(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, audio_id: audio.data.id)
print_message_sent(audio_sent, "audio via id")

######### SEND DOCUMENTS
## with a link
if document.data&.id
  document_sent = client.messages.send_document(
    sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: document.data&.url, caption: "Ignacio Chiazzo"
  )
  print_message_sent(document_sent, "document via url")

  ## with a document id
  document_sent = client.messages.send_document(
    sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, document_id: document.data&.id, caption: "Ignacio Chiazzo"
  ) # modify
  print_message_sent(document_sent, "document via id")
end

######### SEND STICKERS
if sticker.data&.id
  ## with a link
  sticker_sent = client.messages.send_sticker(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: sticker.data.url)
  print_message_sent(sticker_sent, "sticker via url")

  ## with a sticker_id
  sticker_sent = client.messages.send_sticker(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, sticker_id: sticker.data.id)
  print_message_sent(sticker_sent, "sticker via id")
end

######### SEND A TEMPLATE
# Note: The template must have been created previously.

# Send a template with no component
response_with_object = client.messages.send_template(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
                                                  name: "hello_world", language: "en_US", components: [])
puts response_with_object

# Send a template with components (Remember to create the template first).
header_component = WhatsappSdk::Resource::Component.new(
  type: WhatsappSdk::Resource::Component::Type::HEADER
)
image = WhatsappSdk::Resource::Media.new(type: "image", link: "http(s)://URL", caption: "caption")
document = WhatsappSdk::Resource::Media.new(type: "document", link: "http(s)://URL", filename: "txt.rb")
video = WhatsappSdk::Resource::Media.new(type: "video", id: "123")
location = WhatsappSdk::Resource::Location.new(
  latitude: 25.779510, longitude: -80.338631, name: "miami store", address: "820 nw 87th ave, miami, fl"
)

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

parameter_location = WhatsappSdk::Resource::ParameterObject.new(
  type: "location",
  location: location
)

header_component.add_parameter(parameter_text)
header_component.add_parameter(parameter_image)
header_component.add_parameter(parameter_video)
header_component.add_parameter(parameter_document)
header_component.add_parameter(parameter_location)
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
  parameters: [WhatsappSdk::Resource::ButtonParameter.new(type: WhatsappSdk::Resource::ButtonParameter::Type::PAYLOAD,
                                                          payload: "payload")]
)

button_component_2 = WhatsappSdk::Resource::Component.new(
  type: WhatsappSdk::Resource::Component::Type::BUTTON,
  index: 1,
  sub_type: WhatsappSdk::Resource::Component::Subtype::QUICK_REPLY,
  parameters: [WhatsappSdk::Resource::ButtonParameter.new(type: WhatsappSdk::Resource::ButtonParameter::Type::PAYLOAD,
                                                          payload: "payload")]
)

# Send a template with component_json
response_with_json = client.messages.send_template(
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

######### SEND INTERACTIVE MESSAGES
## with reply buttons
interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(
  type: WhatsappSdk::Resource::InteractiveHeader::Type::TEXT,
  text: "I'm the header!"
)

interactive_body = WhatsappSdk::Resource::InteractiveBody.new(
  text: "I'm the body!"
)

interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(
  text: "I'm the footer!"
)

interactive_action = WhatsappSdk::Resource::InteractiveAction.new(
  type: WhatsappSdk::Resource::InteractiveAction::Type::REPLY_BUTTON
)

interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
  title: "I'm a reply button 1",
  id: "button_1"
)
interactive_action.add_reply_button(interactive_reply_button_1)

interactive_reply_button_2 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
  title: "I'm a reply button 2",
  id: "button_2"
)
interactive_action.add_reply_button(interactive_reply_button_2)

interactive_reply_buttons = WhatsappSdk::Resource::Interactive.new(
  type: WhatsappSdk::Resource::Interactive::Type::REPLY_BUTTON,
  header: interactive_header,
  body: interactive_body,
  footer: interactive_footer,
  action: interactive_action
)

client.messages.send_interactive_reply_buttons(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
  interactive: interactive_reply_buttons
)
