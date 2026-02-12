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
  gem "debug"
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
  puts "Message #{type} sent to: #{message_response.contacts.first.input}"
end

def run_and_catch_error(message, &block)
  begin
    yield
  rescue WhatsappSdk::Api::Responses::HttpResponseError => e
    puts "Error: #{e}"
  end
end
##################################################

client = WhatsappSdk::Api::Client.new

# ############################## Templates API ##############################
puts "\n\n ------------------ Testing Templates API ------------------------"
# ## Get list of templates
templates = client.templates.list(business_id: BUSINESS_ID)
puts "GET Templates list : #{ templates.records.map(&:name) }"

## Get message templates namespace
template_namespace = client.templates.get_message_template_namespace(business_id: BUSINESS_ID)
puts "GET template by namespace: #{template_namespace.id}"

## GET
id = templates.records.first.id
if id
  template = client.templates.get(template_id: id)
  puts "GET template by id: #{template.id}"
end

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

new_template = nil

run_and_catch_error("Create a template") do
  new_template = client.templates.create(
    business_id: BUSINESS_ID, name: "seasonal_promotion_2", language: "ka", category: "MARKETING",
    components_json: components_json, allow_category_change: true
  )
  puts "GET template by namespace: #{template_namespace.id}"
end

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

if new_template
  updated_template = client.templates.update(template_id: new_template.id, category: "UTILITY")
  puts "UPDATE template by id: #{updated_template.id}"
end

## Delete a template
run_and_catch_error("Delete a template") do
  delete_template = client.templates.delete(business_id: BUSINESS_ID, name: "seasonal_promotion") # delete by name
  puts "Delete template by id: #{delete_template.id}"
end

# client.templates.delete(business_id: BUSINESS_ID, name: "name2", hsm_id: "243213188351928") # delete by name and id

## Get template analytics
analytics = client.templates.template_analytics(
  business_id: BUSINESS_ID, start_timestamp: 1767236400,
  end_timestamp: 1767322799, template_ids: [id, new_template.id]
)
puts "GET template analytics: #{analytics.records.first}"


# ############################## Business API ##############################
puts "\n\n\n ------------------ Testing Business API -----------------------"

business_profile = client.business_profiles.get(SENDER_ID)
puts "GET Business Profile by id: #{business_profile.about}"

updated_bp = client.business_profiles.update(phone_number_id: SENDER_ID, params: { websites: ["www.ignaciochiazzo.com"] } )
puts "UPDATE Business Profile by id: #{updated_bp} }"

run_and_catch_error("Update business profile") do
  # about can't be set
  updated_bp = client.business_profiles.update(phone_number_id: SENDER_ID, params: { about: "A cool business" } )
end

# ############################## Business Account API ##############################
puts "\n\n\n ------------------ Testing Business Account API -----------------------"

business_account = client.business_accounts.get(BUSINESS_ID)
puts "GET Business Account by id: #{business_account.name}"

business_account = client.business_accounts.get(BUSINESS_ID, fields: %w[id name account_review_status message_template_namespace] )
puts "GET Business Account with fields by id: #{business_account.name}, #{business_account.account_review_status}, #{business_account.message_template_namespace}"

updated_ba = client.business_accounts.update(business_id: BUSINESS_ID, params: { name: 'A cool updated business' } )
puts "UPDATE Business Account by id: #{updated_ba} }"

run_and_catch_error("Update business account") do
  # message_template_namespace can't be set
  client.business_accounts.update(business_id: BUSINESS_ID, params: { message_template_namespace: "namespace" } )
end


############################## Phone Numbers API ##############################
puts "\n\n\n ------------------ Testing Phone Numbers API -----------------------"

# Get phone numbers
registered_number = client.phone_numbers.get(SENDER_ID)
puts "GET Registered number: #{registered_number.id}"

# Get phone number
registered_numbers = client.phone_numbers.list(BUSINESS_ID)
puts "GET Registered numbers: #{registered_numbers.records.map(&:id)}"

# Deregister a phone number - I skip registering so that the number can upload media
# run_and_catch_error("Deregister a phone number") do
#   deregister_number_result = client.phone_numbers.deregister_number(SENDER_ID)
#   puts "DEREGISTER number: #{deregister_number_result}"
# end

# Register a phone number
run_and_catch_error("Register a phone number") do
  register_number_result = client.phone_numbers.register_number(SENDER_ID, 123456)
  puts "REGISTER number: #{register_number_result}"
end

# Register a fake number
begin
  fake_number = "1234567890"
  client.phone_numbers.register_number(fake_number, 123456)
rescue WhatsappSdk::Api::Responses::HttpResponseError => e
  puts "Error: #{e}"
end


############################## Media API ##############################
puts "\n\n\n ------------------ Testing Media API"
##### Image #####
# upload a Image
run_and_catch_error("Upload a Image") do
  uploaded_media = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/whatsapp.png", type: "image/png")
  puts "Uploaded image id: #{uploaded_media&.id}"
end

# get a media Image
if uploaded_media&.id
  image = client.media.get(media_id: uploaded_media.id)
  puts "GET image id: #{image.id}"

  # download media Image
  download_image = client.media.download(url: image.url, file_path: 'test/fixtures/assets/downloaded_image.png', media_type: "image/png")
  puts "Downloaded Image: #{download_image}"

  uploaded_media = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/whatsapp.png", type: "image/png")
  # delete a media
  deleted_media = client.media.delete(media_id: uploaded_media.id)
  puts "Delete image: #{deleted_media.success?}"
else
  puts "No media to download and delete"
end

#### Video ####
# upload a video
uploaded_video = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/riquelme.mp4", type: "video/mp4")
puts "Uploaded video: #{uploaded_video.id}"

video = client.media.get(media_id: uploaded_video.id)

# upload a video
uploaded_video = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/riquelme.mp4", type: "video/mp4")
puts "Uploaded video id: #{uploaded_video.id}"

#### Audio ####
# upload an audio
audio_response = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/downloaded_audio.ogg", type: "audio/ogg")
puts "Uploaded audio id: #{audio_response.id}"

if audio_response&.id
  audio_id = audio_response&.id
  # get a media audio
  audio = client.media.get(media_id: audio_id)
  puts "GET Audio id: #{audio.id}"

  # get a media audio
  audio_link = audio.url
  download_image = client.media.download(url: audio_link, file_path: 'test/fixtures/assets/downloaded_audio2.ogg', media_type: "audio/ogg")
  puts "Download Audio: #{download_image}"
end

# upload a document
document_response = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/document.pdf", type: "application/pdf")
puts "Uploaded document id: #{document_response.id}"

document = client.media.get(media_id: document_response.id)
puts "GET document id: #{document.id}"

# upload a sticker
sticker_response = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/sticker.webp", type: "image/webp")
puts "Uploaded sticker id: #{sticker_response.id}"

sticker = client.media.get(media_id: sticker_response.id)
puts "GET Sticker id: #{sticker.id}"



############################## Messages API ##############################
puts "\n\n\n ------------------ Testing Messages API -----------------------"

######### SEND A TEXT MESSAGE
message_sent = client.messages.send_text(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
                                      message: "Hey there! it's Whatsapp Ruby SDK")
print_message_sent(message_sent, "text")

######### React to a message
message_id = message_sent&.messages.first.id
reaction_1_sent = client.messages.send_reaction(
  sender_id: SENDER_ID,
  recipient_number: RECIPIENT_NUMBER,
  message_id: message_id,
  emoji: "\u{1f550}"
) if message_id

reaction_2_sent = client.messages.send_reaction(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
                                             message_id: message_id, emoji: "⛄️") if message_id
puts "Message Reaction 1: #{reaction_1_sent&.messages.first&.id}"
puts "Message Reaction 2: #{reaction_2_sent&.messages.first&.id}"

######### Reply to a message
message_to_reply_id = message_sent.messages.first.id
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
if image&.id
  image_sent = client.messages.send_image(
    sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: image.url, caption: "Ignacio Chiazzo Profile"
  )
  print_message_sent(image_sent, "image via url")

  # Send an image with an id
  client.messages.send_image(
    sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, image_id: image.id, caption: "Ignacio Chiazzo Profile"
  )
  print_message_sent(image_sent, "image via id")
end

######### SEND AUDIOS
## with a link
audio_sent = client.messages.send_audio(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: audio.url)
print_message_sent(audio_sent, "audio via url")

## with an audio id
audio_sent = client.messages.send_audio(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, audio_id: audio.id)
print_message_sent(audio_sent, "audio via id")

######### SEND DOCUMENTS
## with a link
if document&.id
  document_sent = client.messages.send_document(
    sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: document&.url, caption: "Ignacio Chiazzo"
  )
  print_message_sent(document_sent, "document via url")

  ## with a document id
  document_sent = client.messages.send_document(
    sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, document_id: document&.id, caption: "Ignacio Chiazzo"
  ) # modify
  print_message_sent(document_sent, "document via id")
end

######### SEND STICKERS
if sticker&.id
  ## with a link
  sticker_sent = client.messages.send_sticker(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, link: sticker.url)
  print_message_sent(sticker_sent, "sticker via url")

  ## with a sticker_id
  sticker_sent = client.messages.send_sticker(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, sticker_id: sticker.id)
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
image = WhatsappSdk::Resource::MediaComponent.new(type: "image", link: "http(s)://URL", caption: "caption")
document = WhatsappSdk::Resource::MediaComponent.new(type: "document", link: "http(s)://URL", filename: "txt.rb")
video = WhatsappSdk::Resource::MediaComponent.new(type: "video", id: "123")
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
