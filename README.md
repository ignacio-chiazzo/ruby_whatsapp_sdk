# Ruby Whatsapp SDK
[![Gem Version](https://badge.fury.io/rb/whatsapp_sdk.svg)](https://badge.fury.io/rb/whatsapp_sdk)
[![CircleCI](https://circleci.com/gh/circleci/circleci-docs.svg?style=svg)](https://circleci.com/gh/ignacio-chiazzo/ruby_whatsapp_sdk)
<a href="https://codeclimate.com/github/ignacio-chiazzo/ruby_whatsapp_sdk/maintainability"><img src="https://api.codeclimate.com/v1/badges/169cce95450272e4ad7d/maintainability" /></a>

The SDK provides a set of operations and classes to use the Whatsapp API.
Send stickers, messages, audio, videos, and locations or just ask for the phone numbers through this library in a few steps!


https://user-images.githubusercontent.com/11672878/173238826-6fc0a6f8-d0ee-4eae-8947-7dfd3b8b3446.mov


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

There are three primary resources, `Messages`, `Media` and `PhoneNumbers`. `Messages` allows users to send any kind of message (text, audio, location, video, image, etc.). `Media` allows users to manage media, and `Phone Numbers` enable clients to query the associated phone numbers.

To use `Messages`, `Media` or `PhoneNumbers`, you need to initialize the `Client` that contains auth information. There are two ways to do it

1) Using an initializer
  
```ruby
WhatsappSdk.configure do |config|
  config.access_token = ACCESS_TOKEN
end
```
OR 2) creating a `Client` instance and pass it to the `Messages`, `Medias` or `PhoneNumbers` instance like this:

```ruby
client = WhatsappSdk::Api::Client.new("<ACCESS TOKEN>") # replace this with a valid access token
messages_api = WhatsappSdk::Api::Messages.new(client)
```

Each API operation returns a `WhatsappSdk::Api::Response` that contains `data` and `error` and a couple of helpful functions such as `ok?` and `error?`. There are three types of response `WhatsappSdk::Api::MessageDataResponse`, `WhatsappSdk::Api::PhoneNumberDataResponse` and `WhatsappSdk::Api::PhoneNumbersDataResponse`. Each of them contains different attributes.

## Operations
First, create the client and then create an instance `WhatsappSdk::Api::Messages` that requires a client as a param like this:

```ruby
messages_api = WhatsappSdk::Api::Messages.new
phone_numbers_api = WhatsappSdk::Api::PhoneNumbers.new
medias_api = WhatsappSdk::Api::Medias.new
```

Note: Remember to initialize the client first!

### Phone numbers API
Get the list of phone numbers registered
```ruby
phone_numbers_api.registered_numbers("123456") # accepts a business_id
```

Get the a phone number by id
```ruby
phone_numbers_api.registered_numbers("123456") # accepts a phone_number_id
```

### Media API

Upload a media
```ruby
medias_api.upload(sender_id: SENDER_ID, file_path: "tmp/whatsapp.png", type: "image/png")
```

Get a media
```ruby
media = medias_api.media(media_id: MEDIA_ID)
```

Download media
```ruby
medias_api.download(url: MEDIA_URL, file_path: 'tmp/downloaded_whatsapp.png')
```

Delete a media
```ruby
medias_api.delete(media_id: MEDIA_ID)
```

### Messages API

**Send a text message**

```ruby
messages_api.send_text(sender_id: 1234, recipient_number: "112345678", message: "hola")
```

**Read a message**
```ruby
messages_api.read_message(sender_id: 1234, message_id: "wamid.HBgLMTM0M12345678910=")
```

Note: To get the `message_id` you can set up [Webhooks](https://developers.facebook.com/docs/whatsapp/cloud-api/webhooks/components) that will listen and fire an event when a message is received.


**Send a location message**

```ruby
messages_api.send_location(
  sender_id: 123123, recipient_number: "56789",
  longitude: 45.4215, latitude: 75.6972, name: "nacho", address: "141 cooper street"
)
```

**Send an image message**
It could use a link or an image_id.
```ruby
# with a link
messages_api.send_image(
  sender_id: 123123, recipient_number: "56789", link: "image_link", caption: "Ignacio Chiazzo Profile"
)

# with an image id
messages_api.send_image(
  sender_id: 123123, recipient_number: "56789", image_id: "1234", caption: "Ignacio Chiazzo Profile"
)
```

**Send an audio message**
It could use a link or an audio_id.
```ruby
# with a link
messages_api.send_audio(sender_id: 123123, recipient_number: "56789", link: "audio_link")

# with an audio id
messages_api.send_audio(sender_id: 123123, recipient_number: "56789", audio_id: "1234")
```

**Send a document message**
It could use a link or a document_id.
```ruby
# with a link
messages_api.send_document(
  sender_id: 123123, recipient_number: "56789", link: "document_link", caption: "Ignacio Chiazzo"
)

# with a document id
messages_api.send_document(
  sender_id: 123123, recipient_number: "56789", document_id: "1234", caption: "Ignacio Chiazzo"
)
```

**Send a sticker message**
It could use a link or a sticker_id.
```ruby
# with a link
messages_api.send_sticker(sender_id: 123123, recipient_number: "56789", link: "link")

# with a sticker_id
messages_api.send_sticker(sender_id: 123123, recipient_number: "56789", sticker_id: "1234")
```

**Send contacts message**
To send a contact, you need to create a Contact instance object that contain objects embedded like `addresses`, `birthday`, `emails`, `name`, `org`. See this [guide](/test/contact_helper.rb) to learn how to create contacts objects.

```ruby
contacts = [create_contact(params)]
messages_api.send_contacts(sender_id: 123123, recipient_number: "56789", contacts: contacts)
```

Alernative, you could pass a plain json like this:
```ruby
messages_api.send_contacts(sender_id: 123123, recipient_number: "56789", contacts_json: {...})
```

**Send a template message**
WhatsApp message templates are specific message formats that businesses use to send out notifications or customer care messages to people that have opted in to notifications. Messages can include appointment reminders, shipping information, issue resolution or payment updates.

**Before sending a message template, you need to create one.** visit the [Official API Documentation](https://developers.facebook.com/docs/whatsapp/cloud-api/guides/send-message-templates)

<details> <summary>Component's example</summary>

```ruby
currency = WhatsappSdk::Resource::Currency.new(code: "USD", amount: 1000, fallback_value: "1000")
date_time = WhatsappSdk::Resource::DateTime.new(fallback_value: "2020-01-01T00:00:00Z")
image = WhatsappSdk::Resource::Media.new(type: "image", link: "http(s)://URL")

parameter_image = WhatsappSdk::Resource::ParameterObject.new(type: "image", image: image)
parameter_text = WhatsappSdk::Resource::ParameterObject.new(type: "text", text: "TEXT_STRING")
parameter_currency = WhatsappSdk::Resource::ParameterObject.new(type: "currency", currency: currency)
parameter_date_time = WhatsappSdk::Resource::ParameterObject.new(type: "date_time", date_time: date_time)

header_component = WhatsappSdk::Resource::Component.new(
  type: WhatsappSdk::Resource::Component::Type::HEADER,
  parameters: [parameter_image]
)

body_component = WhatsappSdk::Resource::Component.new(
  type: WhatsappSdk::Resource::Component::Type::BODY,
  parameters: [parameter_text, parameter_currency, parameter_date_time]
)

button_component1 = WhatsappSdk::Resource::Component.new(
  type: WhatsappSdk::Resource::Component::Type::BUTTON,
  index: 0,
  sub_type: WhatsappSdk::Resource::Component::Subtype::QUICK_REPLY,
  parameters: [
    WhatsappSdk::Resource::ButtonParameter.new(type: "payload", payload: "PAYLOAD")
  ]
)

button_component2 = WhatsappSdk::Resource::Component.new(
  type: WhatsappSdk::Resource::Component::Type::BUTTON,
  index: 1,
  sub_type: WhatsappSdk::Resource::Component::Subtype::QUICK_REPLY,
  parameters: [
    WhatsappSdk::Resource::ButtonParameter.new(type: "payload", payload: "PAYLOAD")
  ]
)
@messages_api.send_template(sender_id: 12_345, recipient_number: "12345678", name: "hello_world", language: "en_US", components_json: [component_1])
```

</details>

Alernative, you could pass a plain json like this:
```ruby
@messages_api.send_template(sender_id: 12_345, recipient_number: "12345678", name: "hello_world", language: "en_US", components_json: [{...}])
```

## Example

Visit [the example file](/example.rb) with examples to call the API in a single file.


## Whatsapp Cloud API

- See the [official documentation](https://developers.facebook.com/docs/whatsapp/cloud-api) for the Whatsapp Cloud API.
- For pricing, refer to the [official documentation](https://developers.facebook.com/docs/whatsapp/pricing/). As of today, Whatsapp offers have 1000 conversations free per month.

## Troubleshooting

- If the API response is `success` but the message is not delivered, make sure the device you're sending the message to is using a supported Whatsapp version. [Check documentation](https://developers.facebook.com/docs/whatsapp/cloud-api/support/troubleshooting#message-not-delivered)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk) This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
