# Ruby Whatsapp SDK

The SDK provides a set of operations and classes to use the Whatsapp API.
Send stickers, messages, audio, videos, locations or just ask for the phone numbers through this library in a few steps!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-whatsapp-sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-whatsapp-sdk

## Quick Start

There are two primary resources, `Messages` and `PhoneNumbers`. The first one allows clients to send any kind of message (text, audio, location, video, image, etc.), and the latter will enable clients to query the phone numbers associated.

To use `Messages` or `PhoneNumbers` you need to create a `Client` instance by passing the `access_token` like this:

```ruby
client = WhatsappSdk::Api::Client.new("<ACCESS TOKEN>") # replace this with a valid access token
```

Each API operation returns a `WhatsappSdk::Api::Response` that contains `data` and `error` and a couple of helpful functions such as `ok?` and `error?`. There are three types of response `WhatsappSdk::Api::MessageDataResponse`, `WhatsappSdk::Api::PhoneNumberDataResponse` and `WhatsappSdk::Api::PhoneNumbersDataResponse`. Each of them contains different attributes.

## Operations
First, create the client and then create an instance `WhatsappSdk::Api::Messages` that requires a client as a param like this:

```ruby
client = WhatsappSdk::Api::Client.new("<ACCESS TOKEN>") # replace this with a valid access_token
messages_api = WhatsappSdk::Api::Messages.new(client)
phone_numbers_api = WhatsappSdk::Api::PhoneNumbers.new(client)
```

### Phone numbers API
Get the list of phone numbers registered
```ruby
phone_numbers_api.registered_numbers("123456") # accepts a business_id
```

Get the a phone number by id
```ruby
phone_numbers_api.registered_numbers("123456") # accepts a phone_number_id
```

### Messages API

**Send a text message**

```ruby
messages_api.send_text(sender_id: 1234, recipient_number: "112345678", message: "hola")
```

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
To send a contact, you need to create a Contact instance object that contain objects embedded like 
`addresses`, `birthday`, `emails`, `name`, `org`. See this [guide](/test/contact_helper.rb) to learn how to create contacts objects.

```ruby
contacts = [create_contact(params)]
messages_api.send_contacts(sender_id: 123123, recipient_number: "56789", contacts: contacts)
```

## Example

<details><summary>Example in a single file. </summary>
    
1) Copy this code into a file and save it `example.rb`
2) Replace the `ACCESS_TOKEN` constant with a valid `access_token`. 
3) Run the file with the command `ruby example.rb`

```ruby
# frozen_string_literal: true

require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "whatsapp_sdk", path: "/Users/ignaciochiazzo/src/whatsapp_sdk"
  gem "pry"
  gem "pry-nav"
end

require 'whatsapp_sdk'
require "pry"
require "pry-nav"

ACCESS_TOKEN = "12345" # replace this with a valid access_token
SENDER_ID = 107878721936019
RECEIPIENT_NUMBER = "1234"

client = WhatsappSdk::Api::Client.new(ACCESS_TOKEN) # replace this with a valid access_token
messages_api = WhatsappSdk::Api::Messages.new(client)
phone_numbers_api = WhatsappSdk::Api::PhoneNumbers.new(client)

phone_numbers_api.registered_number("107878721936019")
phone_numbers_api.registered_numbers("114503234599312") 

messages_api.send_text(sender_id: SENDER_ID, recipient_number: RECEIPIENT_NUMBER, message: "hola")
messages_api.send_location(
  sender_id: SENDER_ID, recipient_number: RECEIPIENT_NUMBER, 
  longitude: 45.4215, latitude: 75.6972, name: "nacho", address: "141 cooper street"
)

# Send images

## with a link 
messages_api.send_image(
  sender_id: SENDER_ID, recipient_number: RECEIPIENT_NUMBER, link: "image_link", caption: "Ignacio Chiazzo Profile"
)

## with an image id 
messages_api.send_image(
  sender_id: SENDER_ID, recipient_number: RECEIPIENT_NUMBER, image_id: "1234", caption: "Ignacio Chiazzo Profile"
)

# Send audios
## with a link 
messages_api.send_audio(sender_id: SENDER_ID, recipient_number: RECEIPIENT_NUMBER, link: "audio_link")

## with an audio id 
messages_api.send_audio(sender_id: SENDER_ID, recipient_number: RECEIPIENT_NUMBER, audio_id: "1234")

# Send documents
## with a link 
messages_api.send_document(
  sender_id: SENDER_ID, recipient_number: RECEIPIENT_NUMBER, link: "document_link", caption: "Ignacio Chiazzo"
)

## with a document id 
messages_api.send_document(
  sender_id: SENDER_ID, recipient_number: RECEIPIENT_NUMBER, document_id: "1234", caption: "Ignacio Chiazzo"
)

# send stickers
## with a link 
messages_api.send_sticker(sender_id: SENDER_ID, recipient_number: RECEIPIENT_NUMBER, link: "link")

## with a sticker_id
messages_api.send_sticker(sender_id: SENDER_ID, recipient_number: RECEIPIENT_NUMBER, sticker_id: "1234")
binding.pry

```
</details>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/ignacio-chiazzo/whatsapp_sdk](https://github.com/ignacio-chiazzo/whatsapp_sdk) This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
