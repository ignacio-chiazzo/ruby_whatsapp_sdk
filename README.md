# Ruby Whatsapp SDK

[![Gem Version](https://badge.fury.io/rb/whatsapp_sdk.svg)](https://badge.fury.io/rb/whatsapp_sdk)
[![CircleCI](https://circleci.com/gh/circleci/circleci-docs.svg?style=svg)](https://circleci.com/gh/ignacio-chiazzo/ruby_whatsapp_sdk)
<a href="https://codeclimate.com/github/ignacio-chiazzo/ruby_whatsapp_sdk/maintainability"><img src="https://api.codeclimate.com/v1/badges/169cce95450272e4ad7d/maintainability" /></a>

The SDK provides a set of operations and classes to use the Whatsapp API.
Send stickers, messages, audio, videos, locations, react and reply to messages or just ask for the phone numbers through this library in a few steps!

## Demo

https://user-images.githubusercontent.com/11672878/173238826-6fc0a6f8-d0ee-4eae-8947-7dfd3b8b3446.mov

**Check the [Ruby on Rails Whatsapp example repository](https://github.com/ignacio-chiazzo/ruby_on_rails_whatsapp_example)** that uses this library to send messages.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'whatsapp_sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install whatsapp_sdk

## Quick Start

There are three primary resources, `Messages`, `Media` and `PhoneNumbers`. `Messages` allows users to send any message (text, audio, location, video, image, etc.). `Media` allows users to manage media, and `Phone Numbers` enable clients to query the associated phone numbers.

To use `Messages`, `Media` or `PhoneNumbers`, you need to initialize the `Client` that contains auth information. There are two ways to do it.

#### Option 1) Use an initializer

```ruby
# config/initializers/whatsapp_sdk.rb
WhatsappSdk.configure do |config|
  config.access_token = ACCESS_TOKEN
  config.api_version = API_VERSION
  config.logger = Logger.new(STDOUT) # optional, Faraday logger to attach
  config.logger_options = { bodies: true } # optional, they are all valid logger_options for Faraday
end
```

Notes:
- Optionally, you can specify the desired API version to use (defaults to the latest version if omitted).
Available API version can be found [here](https://developers.facebook.com/docs/graph-api/changelog/versions).
- You can attach a logger. More Details on Faraday Logger Options are [here](https://lostisland.github.io/faraday/#/middleware/included/logging?id=logging).


#### Option 2) Create a `Client` instance :

```ruby

# without
client = WhatsappSdk::Api::Client.new("<ACCESS TOKEN>") # replace this with a valid access token

# OR optionally use a logger, api_version and
logger = Logger.new(STDOUT)
logger_options = { bodies: true }
client = WhatsappSdk::Api::Client.new("<ACCESS TOKEN>", "<API VERSION>", logger, logger_options)
```

## Set up a Meta app

<details><summary>1) Create a Meta Business app </summary>
<img width="1063" alt="Screen Shot 2022-09-05 at 11 03 47 AM" src="https://user-images.githubusercontent.com/11672878/188477795-4745a71a-a4b5-41e2-bef1-e41d3060e02b.png">
</details>

<details><summary>2) Add Whatsapp to your Application</summary>
<img width="1087" alt="Screen Shot 2022-09-05 at 11 05 43 AM" src="https://user-images.githubusercontent.com/11672878/188478100-98b3bf0a-fec7-4ea1-a492-aeb90a6b06bd.png">
</details>

<details><summary>3) Add a phone number to your account</summary>
<img width="972" alt="Screen Shot 2022-09-05 at 11 09 22 AM" src="https://user-images.githubusercontent.com/11672878/188478741-8a6105e8-2776-4493-bba9-05a62082a5aa.png">
</details>

Try sending a message to your phone in the UI.

<details><summary>4) Copy the ACCESS_TOKEN, the SENDER_ID, the BUSINESS_ID and the RECIPIENT_NUMBER</summary>
<img width="1010" alt="Screen Shot 2022-09-05 at 11 13 24 AM" src="https://user-images.githubusercontent.com/11672878/188480634-369f8de1-b851-4735-86de-f49e96f78d8c.png">
</details>

</details>

<details><summary>5) Use the GEM to interact with Whatsapp</summary>

Example:

1. Install the gem by running `gem install whatsapp_sdk` in the gem.
2. Open the irb terminal by running `irb`
3. `require "whatsapp_sdk"`
4. Set up the `ACCESS_TOKEN`, the `SENDER_ID`, the `BUSINESS_ID` and the `RECIPIENT_NUMBER` in variables.

```ruby
ACCESS_TOKEN = "EAAZAvvr0DZBs0BABRLF8zohP5Epc6pyNu"
BUSINESS_ID = 1213141516171819
SENDER_ID = 1234567891011
RECIPIENT_NUMBER = 12398765432
```

5. Configure the Client by running

```ruby
WhatsappSdk.configure do |config|
  config.access_token = ACCESS_TOKEN
end
```

6. Try the Phone Numbers API or Messages API

Phone Numbers API

```ruby
registered_number = client.phone_numbers.registered_number(SENDER_ID)
```

Messages API

```ruby
message_sent = client.messages.send_text(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
                                      message: "Hey there! it's Whatsapp Ruby SDK")
```

Check the [example.rb file](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/blob/main/example.rb) for more examples.

</details>

## Sneak Peek

```ruby
client = WhatsappSdk::Api::Client.new("<ACCESS TOKEN>") # replace this with a valid access token

client.phone_numbers.register_number(SENDER_ID, 123456) # register the phone number to uplaod media and send message from.

# send a text and a location
client.messages.send_text(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,message: "Hey there! it's Whatsapp Ruby SDK")

client.messages.send_location(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, longitude: -75.6898604, latitude: 45.4192206, name: "Ignacio", address: "My house")

# upload a photo and send it
image = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/whatsapp.png", type: "image/png")
client.messages.send_image(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, image_id: image.id)

# upload a sticker and send it
sticker = client.media.upload(sender_id: SENDER_ID, file_path: "test/fixtures/assets/sticker.webp", type: "image/webp")
client.messages.send_sticker(sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER, sticker_id: sticker.id)
```

## APIs

### Templates

<details>

```ruby
# Get list of templates
client.templates.list(business_id: BUSINESS_ID)

# Get Message Template Namespace
# The message template namespace is required to send messages using the message templates.
client.templates.get_message_template_namespace(business_id: BUSINESS_ID)

# Create a template
client.templates.create(
  business_id: BUSINESS_ID, name: "seasonal_promotion", language: "en_US", category: "MARKETING",
  components_json: components_json, allow_category_change: true
)

# Delete a template
client.templates.delete(business_id: BUSINESS_ID, name: "my_name") # delete by name
```
</details>

### Business Profile API

<details>

```ruby
# Get the details of your business
client.business_profiles.get(phone_number_id)

# Update the details of your business
client.business_profiles.update(phone_number_id: SENDER_ID, params: { about: "A very cool business" } )
```
</details>

### Phone numbers API

<details>

```ruby
# Get the list of phone numbers registered
client.phone_numbers.list(business_id)

# Get the a phone number by id
client.phone_numbers.get(phone_number_id)

# Register a phone number
client.phone_numbers.register_number(phone_number_id, pin)

# Deregister a phone number
client.phone_numbers.deregister_number(phone_number_id)
```

</details>

### Media API

<details>

```ruby
# Upload a media
client.media.upload(sender_id: SENDER_ID, file_path: "tmp/whatsapp.png", type: "image/png")

# Get a media
media = client.media.get(media_id: MEDIA_ID)

# Download media
client.media.download(url: MEDIA_URL, file_path: 'tmp/downloaded_whatsapp.png', media_type: "image/png")

# Delete a media
client.media.delete(media_id: MEDIA_ID)
```
</details>

### Messages API

<details>

```ruby
# Send a text message
client.messages.send_text(sender_id: 1234, recipient_number: 112345678, message: "hola")

# Read a message
client.messages.read_message(sender_id: 1234, message_id: "wamid.HBgLMTM0M12345678910=")

# Note: To get the `message_id` you can set up [Webhooks](https://developers.facebook.com/docs/whatsapp/cloud-api/webhooks/components) that will listen and fire an event when a message is received.

# Send a reaction to message
#   To send a reaction to a message, you need to obtain the message id and look for the emoji's unicode you want to use.
client.messages.send_reaction(sender_id: 123_123, recipient_number: 56_789, message_id: "12345", emoji: "\u{1f550}")
client.messages.send_reaction(sender_id: 123_123, recipient_number: 56_789, message_id: "12345", emoji: "⛄️")

# Reply to a message
# To reply to a message, just include the id of the message in the `client.messages` methods. For example, to reply to a text message include the following:
client.messages.send_text(sender_id: 123_123, recipient_number: 56_789, message: "I'm a reply", message_id: "wamid.1234")

# Send a location message
client.messages.send_location(
  sender_id: 123123, recipient_number: 56789,
  longitude: 45.4215, latitude: 75.6972, name: "nacho", address: "141 cooper street"
)

# Send an image message
#  It uses a link or an image_id.
#  with a link
client.messages.send_image(sender_id: 123123, recipient_number: 56789, link: "image_link", caption: "Ignacio Chiazzo Profile")

# with an image id
client.messages.send_image(sender_id: 123123, recipient_number: 56789, image_id: "1234", caption: "Ignacio Chiazzo Profile")


# Send an audio message
# It uses a link or an audio_id.
# with a link
client.messages.send_audio(sender_id: 123123, recipient_number: 56789, link: "audio_link")

# with an audio id
client.messages.send_audio(sender_id: 123123, recipient_number: 56789, audio_id: "1234")

# Send a document message
# It uses a link or a document_id.
# with a link
client.messages.send_document(sender_id: 123123, recipient_number: 56789, link: "document_link", caption: "Ignacio Chiazzo")

# with a document id
client.messages.send_document(sender_id: 123123, recipient_number: 56789, document_id: "1234", caption: "Ignacio Chiazzo")
# Note, you can specify the filename via argument [`filename`](https://developers.facebook.com/docs/whatsapp/cloud-api/reference/messages).

# Send a sticker message
#  It could use a link or a sticker_id.
#  with a link
client.messages.send_sticker(sender_id: 123123, recipient_number: 56789, link: "link")

# with a sticker_id
client.messages.send_sticker(sender_id: 123123, recipient_number: 56789, sticker_id: "1234")

# Send contacts message
# To send a contact, you need to create a Contact instance object that contain objects embedded like `addresses`, `birthday`, `emails`, `name`, `org`. See this [guide](/test/contact_helper.rb) to learn how to create contacts objects.
client.messages.send_contacts(sender_id: 123123, recipient_number: 56789, contacts: [create_contact(params)])

# Alternatively, you could pass a plain json like this:
client.messages.send_contacts(sender_id: 123123, recipient_number: 56789, contacts_json: {...})

# Send a template message
# WhatsApp message templates are specific message formats that businesses use to send out notifications or customer care messages to people that have opted in to notifications. Messages can include appointment reminders, shipping information, issue resolution or payment updates.

# Before sending a message template, you need to create one. visit the [Official API Documentation](https://developers.facebook.com/docs/whatsapp/cloud-api/guides/send-message-templates)
```

<details> <summary>Component's example</summary>

```ruby
currency = WhatsappSdk::Resource::Currency.new(code: "USD", amount: 1000, fallback_value: "1000")
date_time = WhatsappSdk::Resource::DateTime.new(fallback_value: "2020-01-01T00:00:00Z")
media_component = WhatsappSdk::Resource::MediaComponent.new(type: "image", link: "http(s)://URL")
location = WhatsappSdk::Resource::Location.new(
  latitude: 25.779510, longitude: -80.338631, name: "miami store", address: "820 nw 87th ave, miami, fl"
)

parameter_image = WhatsappSdk::Resource::ParameterObject.new(type: "image", image: media_component)
parameter_text = WhatsappSdk::Resource::ParameterObject.new(type: "text", text: "TEXT_STRING")
parameter_currency = WhatsappSdk::Resource::ParameterObject.new(type: "currency", currency: currency)
parameter_date_time = WhatsappSdk::Resource::ParameterObject.new(type: "date_time", date_time: date_time)
parameter_location = WhatsappSdk::Resource::ParameterObject.new(type: "location", location: location)

header_component = WhatsappSdk::Resource::Component.new(type: "header", parameters: [parameter_image])

body_component = WhatsappSdk::Resource::Component.new(
  type: "body",
  parameters: [parameter_text, parameter_currency, parameter_date_time]
)

button_component1 = WhatsappSdk::Resource::Component.new(
  type: "button",
  index: 0,
  sub_type: "quick_reply",
  parameters: [
    WhatsappSdk::Resource::ButtonParameter.new(type: "payload", payload: "PAYLOAD")
  ]
)

button_component2 = WhatsappSdk::Resource::Component.new(
  type: "button",
  index: 1,
  sub_type: "quick_reply",
  parameters: [
    WhatsappSdk::Resource::ButtonParameter.new(type: "payload", payload: "PAYLOAD")
  ]
)

location_component = WhatsappSdk::Resource::Component.new(type: "header", parameters: [parameter_location])
client.messages.send_template(
  sender_id: 12_345, recipient_number: 12345678, name: "hello_world", language: "en_US", components: [...]
)
```

</details>

Alternatively, you could pass a plain json like this:

```ruby
client.messages.send_template(sender_id: 12_345, recipient_number: 12345678, name: "hello_world", language: "en_US", components_json: [{...}])
```

**Send interactive messages**
Visit the [Official API Documentation](https://developers.facebook.com/docs/whatsapp/cloud-api/guides/send-messages#interactive-messages)

<details>
<summary>List Message's example</summary>

```ruby
interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(type: "text", text: "I am the header!")
interactive_body = WhatsappSdk::Resource::InteractiveBody.new(text: "I am the body!")
interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(text: "I am the footer!")
interactive_action = WhatsappSdk::Resource::InteractiveAction.new(type: "list_message")

interactive_action.button = "I am the button CTA"

interactive_section_1 = WhatsappSdk::Resource::InteractiveActionSection.new(title: "I am the section 1")
interactive_section_1_row_1 = WhatsappSdk::Resource::InteractiveActionSectionRow.new(
  title: "I am the row 1 title",
  id: "section_1_row_1",
  description: "I am the optional section 1 row 1 description"
)
interactive_section_1.add_row(interactive_section_1_row_1)
interactive_action.add_section(interactive_section_1)

interactive_list_messages = WhatsappSdk::Resource::Interactive.new(
  type: "list",
  header: interactive_header,
  body: interactive_body,
  footer: interactive_footer,
  action: interactive_action
)

client.messages.send_interactive_list_messages(
  sender_id: SENDER_ID, recipient_number: RECIPIENT_NUMBER,
  interactive: interactive_list_messages
)
```

</details>

Alternatively, you could pass a plain json like this:

```ruby
client.messages.send_interactive_list_messages(
  sender_id: 12_345, recipient_number: 1234567890
  interactive_json: {...}
)
```

<details>
<summary>Reply Button's example</summary>

```ruby
interactive_header = WhatsappSdk::Resource::InteractiveHeader.new(type: "text", text: "I am the header!")
interactive_body = WhatsappSdk::Resource::InteractiveBody.new(text: "I am the body!")
interactive_footer = WhatsappSdk::Resource::InteractiveFooter.new(text: "I am the footer!")

interactive_action = WhatsappSdk::Resource::InteractiveAction.new(type: "reply_button")
interactive_reply_button_1 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
  title: "I am the reply button 1",
  id: "button_1"
)
interactive_action.add_reply_button(interactive_reply_button_1)

interactive_reply_button_2 = WhatsappSdk::Resource::InteractiveActionReplyButton.new(
  title: "I am the reply button 2",
  id: "button_2"
)
interactive_action.add_reply_button(interactive_reply_button_2)

interactive_reply_buttons = WhatsappSdk::Resource::Interactive.new(
  type: "reply_button",
  header: interactive_header,
  body: interactive_body,
  footer: interactive_footer,
  action: interactive_action
)

client.messages.send_interactive_reply_buttons(
  sender_id: 12_345, recipient_number: 1234567890,
  interactive: interactive_reply_buttons
)
```

</details>

Alternative, you could pass a plain json like this:

```ruby
client.messages.send_interactive_reply_buttons(
  sender_id: 12_345, recipient_number: 1234567890
  interactive_json: {...}
)
```

</details>

### Errors

If the API returns an error then an exception `WhatsappSdk::Api::Responses::HttpResponseError` is raised. The  object contains information returned by the Cloud API. For more information about the potential error check the [official documentation](https://developers.facebook.com/docs/whatsapp/cloud-api/support/error-codes/).

## Examples

Visit [the example file](/example.rb) with examples to call the API in a single file.

## Whatsapp Cloud API

- See the [official documentation](https://developers.facebook.com/docs/whatsapp/cloud-api) for the Whatsapp Cloud API.
- For pricing, refer to the [official documentation](https://developers.facebook.com/docs/whatsapp/pricing/). As of today, Whatsapp offers have 1000 conversations free per month.

## Troubleshooting

If you try to send a text message directly without a message template created and approved in your Meta control panel, you can't start a chat with other people. But if you receive a message before, it's possible to send a message.

If the API response is still `success`, but the message is not delivered:
  - ensure the device you're sending the message to is using a supported Whatsapp version. [Check documentation](https://developers.facebook.com/docs/whatsapp/cloud-api/support/troubleshooting#message-not-delivered). Try also replying a message to the number you are registered on your Whatsapp.
- Ensure your Meta App uses an API version greater than or equal to `v.14`.
- Ensure that the Panel in the Facebook dashboard doesn't display any errors.

Note: Sometimes the messages are delayed; see [Meta documentation](https://developers.facebook.com/docs/whatsapp/on-premises/guides/send-message-performance#delays).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

Run `bundle exec rake install` to install this gem onto your local machine. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Run all the tests

- **Unit tests:** Run `rake test`
- **Sorbet Typecheck:** run `srb tc`
- **Linters:** `bundle exec rubocop`

To update the Cloud API version update the version in `lib/whatsapp_sdk/api/api_configuration.rb`. Check the [Cloud API changelog for API udpates](https://developers.facebook.com/docs/whatsapp/business-platform/changelog#api-error-response-behavior).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk) This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

If you want a feature to be implemented in the gem, please, open an issue and we will take a look as soon as we can.

Do you want to contribute and are unsure where to start? Ping me on Twitter, and I will help you!

Check [Contributing](/CONTRIBUTING.MD) file.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
