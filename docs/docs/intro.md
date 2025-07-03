---
sidebar_position: 1
---

# Getting Started

Welcome to the **Ruby WhatsApp SDK** documentation! This SDK provides a comprehensive Ruby interface for the WhatsApp Cloud API, allowing you to send messages, manage media, and handle WhatsApp business operations.

## What is Ruby WhatsApp SDK?

The Ruby WhatsApp SDK is a powerful library that enables Ruby developers to:

- 📱 Send text messages, images, audio, video, and documents
- 🎯 Send interactive messages with buttons and lists
- 📍 Send location messages
- 👥 Send contact information
- 📋 Use message templates
- 🔧 Manage phone numbers and business profiles
- 📁 Upload and manage media files

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'whatsapp_sdk'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install whatsapp_sdk
```

## Quick Start

### 1. Set up your Meta Business App

Before using the SDK, you need to set up a Meta Business App with WhatsApp. Follow the [Meta setup guide](https://developers.facebook.com/docs/whatsapp/cloud-api/get-started) to:

1. Create a Meta Business app
2. Add WhatsApp to your application
3. Add a phone number to your account
4. Get your access token and phone number ID

### 2. Configure the Client

There are two ways to configure the WhatsApp client:

#### Option 1: Using an initializer (Recommended for Rails)

```ruby
# config/initializers/whatsapp_sdk.rb
WhatsappSdk.configure do |config|
  config.access_token = 'YOUR_ACCESS_TOKEN'
  config.api_version = 'v17.0' # optional
  config.logger = Logger.new(STDOUT) # optional
end
```

#### Option 2: Create a Client instance

```ruby
client = WhatsappSdk::Api::Client.new('YOUR_ACCESS_TOKEN')
```

### 3. Send your first message

```ruby
# Send a simple text message
client.messages.send_text(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: 'RECIPIENT_PHONE_NUMBER',
  message: 'Hello from Ruby WhatsApp SDK!'
)
```

## What's Next?

- 🚀 [API Reference](./api/messages.md) - Explore all available methods
- 📖 [Examples](./examples.md) - See practical code examples
- 🔧 [Configuration](./configuration.md) - Learn about advanced configuration options
- 🐛 [Troubleshooting](./troubleshooting.md) - Common issues and solutions

## Need Help?

- 📚 Check out the [GitHub repository](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk)
- 🐛 Report issues on [GitHub Issues](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/issues)
- 💎 View the gem on [RubyGems](https://rubygems.org/gems/whatsapp_sdk)