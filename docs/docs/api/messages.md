---
sidebar_position: 1
---

# Messages API

The Messages API allows you to send various types of messages through WhatsApp, including text, media, location, contacts, and interactive messages.

## Configuration

Before using the Messages API, ensure you have configured your client:

```ruby
client = WhatsappSdk::Api::Client.new('YOUR_ACCESS_TOKEN')
# OR use the global configuration
WhatsappSdk.configure do |config|
  config.access_token = 'YOUR_ACCESS_TOKEN'
end
```

## Text Messages

### Send a text message

```ruby
response = client.messages.send_text(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  message: 'Hello, World!'
)
```

### Reply to a message

To reply to a specific message, include the `message_id`:

```ruby
client.messages.send_text(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  message: 'This is a reply',
  message_id: 'wamid.1234567890'
)
```

## Media Messages

### Send an image

```ruby
# Using a URL
client.messages.send_image(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  link: 'https://example.com/image.jpg',
  caption: 'Check out this image!'
)

# Using an uploaded media ID
client.messages.send_image(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  image_id: 'MEDIA_ID',
  caption: 'Check out this image!'
)
```

### Send audio

```ruby
# Using a URL
client.messages.send_audio(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  link: 'https://example.com/audio.mp3'
)

# Using an uploaded media ID
client.messages.send_audio(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  audio_id: 'MEDIA_ID'
)
```

### Send video

```ruby
# Using a URL
client.messages.send_video(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  link: 'https://example.com/video.mp4',
  caption: 'Check out this video!'
)

# Using an uploaded media ID
client.messages.send_video(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  video_id: 'MEDIA_ID',
  caption: 'Check out this video!'
)
```

### Send document

```ruby
# Using a URL
client.messages.send_document(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  link: 'https://example.com/document.pdf',
  caption: 'Here is your document',
  filename: 'report.pdf'
)

# Using an uploaded media ID
client.messages.send_document(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  document_id: 'MEDIA_ID',
  caption: 'Here is your document',
  filename: 'report.pdf'
)
```

### Send sticker

```ruby
# Using a URL
client.messages.send_sticker(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  link: 'https://example.com/sticker.webp'
)

# Using an uploaded media ID
client.messages.send_sticker(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  sticker_id: 'MEDIA_ID'
)
```

## Location Messages

```ruby
client.messages.send_location(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  longitude: -122.4194,
  latitude: 37.7749,
  name: 'San Francisco',
  address: 'San Francisco, CA, USA'
)
```

## Contact Messages

```ruby
# Create a contact
contact = WhatsappSdk::Resource::Contact.new(
  name: WhatsappSdk::Resource::Name.new(
    formatted_name: 'John Doe',
    first_name: 'John',
    last_name: 'Doe'
  ),
  phones: [
    WhatsappSdk::Resource::PhoneNumber.new(
      phone: '+1234567890',
      type: 'WORK'
    )
  ]
)

client.messages.send_contacts(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  contacts: [contact]
)
```

## Interactive Messages

### List Messages

```ruby
# Create interactive components
header = WhatsappSdk::Resource::InteractiveHeader.new(
  type: 'text',
  text: 'Choose an option'
)

body = WhatsappSdk::Resource::InteractiveBody.new(
  text: 'Please select from the options below:'
)

footer = WhatsappSdk::Resource::InteractiveFooter.new(
  text: 'Powered by Ruby WhatsApp SDK'
)

# Create action with list
action = WhatsappSdk::Resource::InteractiveAction.new(type: 'list_message')
action.button = 'View Options'

# Create section and rows
section = WhatsappSdk::Resource::InteractiveActionSection.new(title: 'Options')
section.add_row(WhatsappSdk::Resource::InteractiveActionSectionRow.new(
  title: 'Option 1',
  id: 'option_1',
  description: 'Description for option 1'
))
section.add_row(WhatsappSdk::Resource::InteractiveActionSectionRow.new(
  title: 'Option 2',
  id: 'option_2',
  description: 'Description for option 2'
))

action.add_section(section)

# Create interactive message
interactive = WhatsappSdk::Resource::Interactive.new(
  type: 'list',
  header: header,
  body: body,
  footer: footer,
  action: action
)

client.messages.send_interactive_list_messages(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  interactive: interactive
)
```

### Reply Button Messages

```ruby
# Create interactive components
header = WhatsappSdk::Resource::InteractiveHeader.new(
  type: 'text',
  text: 'Quick Actions'
)

body = WhatsappSdk::Resource::InteractiveBody.new(
  text: 'Choose a quick action:'
)

# Create action with reply buttons
action = WhatsappSdk::Resource::InteractiveAction.new(type: 'reply_button')

action.add_reply_button(WhatsappSdk::Resource::InteractiveActionReplyButton.new(
  title: 'Yes',
  id: 'yes_button'
))

action.add_reply_button(WhatsappSdk::Resource::InteractiveActionReplyButton.new(
  title: 'No',
  id: 'no_button'
))

# Create interactive message
interactive = WhatsappSdk::Resource::Interactive.new(
  type: 'reply_button',
  header: header,
  body: body,
  action: action
)

client.messages.send_interactive_reply_buttons(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  interactive: interactive
)
```

## Reactions

Send a reaction to a message:

```ruby
client.messages.send_reaction(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  message_id: 'MESSAGE_ID',
  emoji: '👍'
)

# Remove a reaction
client.messages.send_reaction(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  message_id: 'MESSAGE_ID',
  emoji: ''
)
```

## Message Status

### Read a message

Mark a message as read:

```ruby
client.messages.read_message(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  message_id: 'MESSAGE_ID'
)
```

## Template Messages

Send a pre-approved message template:

```ruby
# Create template components
components = [
  WhatsappSdk::Resource::Component.new(
    type: 'body',
    parameters: [
      WhatsappSdk::Resource::ParameterObject.new(
        type: 'text',
        text: 'John Doe'
      )
    ]
  )
]

client.messages.send_template(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  name: 'hello_world',
  language: 'en_US',
  components: components
)
```

## Error Handling

All methods return response objects. Check for errors:

```ruby
response = client.messages.send_text(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  message: 'Hello!'
)

if response.error?
  puts "Error: #{response.error.message}"
else
  puts "Message sent successfully! ID: #{response.data.id}"
end
```

## Next Steps

- [Media API](./media.md) - Learn how to upload and manage media files
- [Templates API](./templates.md) - Create and manage message templates
- [Phone Numbers API](./phone-numbers.md) - Manage your WhatsApp phone numbers