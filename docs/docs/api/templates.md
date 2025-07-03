---
sidebar_position: 3
---

# Templates API

Message templates are pre-approved message formats for sending notifications and customer care messages to users who have opted in to receive them.

## Overview

WhatsApp message templates are required for:
- Sending messages to users who haven't messaged you in the last 24 hours
- Notifications (order updates, appointment reminders, etc.)
- Marketing messages
- Customer care messages

## Get Templates

Retrieve all templates for your business:

```ruby
response = client.templates.list(business_id: 'YOUR_BUSINESS_ID')

if response.error?
  puts "Error: #{response.error.message}"
else
  templates = response.data
  templates.each do |template|
    puts "Template: #{template.name} (#{template.language})"
    puts "Status: #{template.status}"
    puts "Category: #{template.category}"
  end
end
```

## Get Template Namespace

Get the message template namespace (required for sending template messages):

```ruby
response = client.templates.get_message_template_namespace(
  business_id: 'YOUR_BUSINESS_ID'
)

if response.error?
  puts "Error: #{response.error.message}"
else
  namespace = response.data
  puts "Template namespace: #{namespace}"
end
```

## Create Templates

### Simple Text Template

```ruby
# Create a simple text template
components_json = [
  {
    type: 'BODY',
    text: 'Hello {{1}}, your order #{{2}} has been confirmed!'
  }
]

response = client.templates.create(
  business_id: 'YOUR_BUSINESS_ID',
  name: 'order_confirmation',
  language: 'en_US',
  category: 'TRANSACTIONAL',
  components_json: components_json
)

if response.error?
  puts "Error creating template: #{response.error.message}"
else
  puts "Template created successfully: #{response.data.id}"
end
```

### Template with Header and Footer

```ruby
components_json = [
  {
    type: 'HEADER',
    format: 'TEXT',
    text: 'Order Update'
  },
  {
    type: 'BODY',
    text: 'Hi {{1}}, your order #{{2}} has been {{3}}. Track it here: {{4}}'
  },
  {
    type: 'FOOTER',
    text: 'Thank you for choosing us!'
  }
]

response = client.templates.create(
  business_id: 'YOUR_BUSINESS_ID',
  name: 'order_status_update',
  language: 'en_US',
  category: 'TRANSACTIONAL',
  components_json: components_json
)
```

### Template with Media Header

```ruby
components_json = [
  {
    type: 'HEADER',
    format: 'IMAGE',
    example: {
      header_handle: ['https://example.com/product-image.jpg']
    }
  },
  {
    type: 'BODY',
    text: 'Hi {{1}}! Check out our latest product: {{2}}. Special price: ${{3}}'
  },
  {
    type: 'FOOTER',
    text: 'Limited time offer!'
  }
]

response = client.templates.create(
  business_id: 'YOUR_BUSINESS_ID',
  name: 'product_promotion',
  language: 'en_US',
  category: 'MARKETING',
  components_json: components_json
)
```

### Template with Buttons

```ruby
components_json = [
  {
    type: 'BODY',
    text: 'Your appointment is confirmed for {{1}} at {{2}}. Please choose an option:'
  },
  {
    type: 'BUTTONS',
    buttons: [
      {
        type: 'QUICK_REPLY',
        text: 'Confirm'
      },
      {
        type: 'QUICK_REPLY',
        text: 'Reschedule'
      },
      {
        type: 'QUICK_REPLY',
        text: 'Cancel'
      }
    ]
  }
]

response = client.templates.create(
  business_id: 'YOUR_BUSINESS_ID',
  name: 'appointment_confirmation',
  language: 'en_US',
  category: 'TRANSACTIONAL',
  components_json: components_json
)
```

## Send Template Messages

### Basic Template Message

```ruby
# Send a simple template with text parameters
components = [
  WhatsappSdk::Resource::Component.new(
    type: 'body',
    parameters: [
      WhatsappSdk::Resource::ParameterObject.new(
        type: 'text',
        text: 'John Doe'
      ),
      WhatsappSdk::Resource::ParameterObject.new(
        type: 'text',
        text: 'ORD123456'
      )
    ]
  )
]

response = client.messages.send_template(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  name: 'order_confirmation',
  language: 'en_US',
  components: components
)
```

### Template with Media Header

```ruby
# Upload media first
upload_response = client.media.upload(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  file_path: 'assets/product-image.jpg',
  type: 'image/jpeg'
)

if upload_response.error?
  puts "Media upload failed: #{upload_response.error.message}"
else
  # Create media component
  media_component = WhatsappSdk::Resource::MediaComponent.new(
    type: 'image',
    media_id: upload_response.data.id
  )

  components = [
    WhatsappSdk::Resource::Component.new(
      type: 'header',
      parameters: [
        WhatsappSdk::Resource::ParameterObject.new(
          type: 'image',
          image: media_component
        )
      ]
    ),
    WhatsappSdk::Resource::Component.new(
      type: 'body',
      parameters: [
        WhatsappSdk::Resource::ParameterObject.new(
          type: 'text',
          text: 'John Doe'
        ),
        WhatsappSdk::Resource::ParameterObject.new(
          type: 'text',
          text: 'Premium Widget'
        ),
        WhatsappSdk::Resource::ParameterObject.new(
          type: 'text',
          text: '99.99'
        )
      ]
    )
  ]

  response = client.messages.send_template(
    sender_id: 'YOUR_PHONE_NUMBER_ID',
    recipient_number: '1234567890',
    name: 'product_promotion',
    language: 'en_US',
    components: components
  )
end
```

### Template with Currency and Date Parameters

```ruby
# Create currency parameter
currency = WhatsappSdk::Resource::Currency.new(
  code: 'USD',
  amount: 1999, # Amount in cents
  fallback_value: '$19.99'
)

# Create date/time parameter
date_time = WhatsappSdk::Resource::DateTime.new(
  fallback_value: 'March 15, 2024 at 2:30 PM'
)

components = [
  WhatsappSdk::Resource::Component.new(
    type: 'body',
    parameters: [
      WhatsappSdk::Resource::ParameterObject.new(
        type: 'text',
        text: 'Jane Smith'
      ),
      WhatsappSdk::Resource::ParameterObject.new(
        type: 'currency',
        currency: currency
      ),
      WhatsappSdk::Resource::ParameterObject.new(
        type: 'date_time',
        date_time: date_time
      )
    ]
  )
]

response = client.messages.send_template(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  name: 'payment_reminder',
  language: 'en_US',
  components: components
)
```

## Template Categories

Templates must be assigned to one of these categories:

- **TRANSACTIONAL**: Order updates, appointment confirmations, account notifications
- **MARKETING**: Promotions, new product announcements, special offers
- **OTP**: One-time passwords and verification codes

```ruby
# Transactional template
client.templates.create(
  business_id: 'YOUR_BUSINESS_ID',
  name: 'shipping_update',
  language: 'en_US',
  category: 'TRANSACTIONAL',
  components_json: components_json
)

# Marketing template
client.templates.create(
  business_id: 'YOUR_BUSINESS_ID',
  name: 'flash_sale',
  language: 'en_US',
  category: 'MARKETING',
  components_json: components_json
)
```

## Update Templates

Update an existing template:

```ruby
updated_components = [
  {
    type: 'BODY',
    text: 'Hi {{1}}, your order #{{2}} has been updated. New status: {{3}}'
  }
]

response = client.templates.update(
  business_id: 'YOUR_BUSINESS_ID',
  template_id: 'TEMPLATE_ID',
  category: 'TRANSACTIONAL',
  components_json: updated_components
)
```

## Delete Templates

Delete a template by name or ID:

```ruby
# Delete by name
response = client.templates.delete(
  business_id: 'YOUR_BUSINESS_ID',
  name: 'old_template'
)

# Delete by ID
response = client.templates.delete(
  business_id: 'YOUR_BUSINESS_ID',
  template_id: 'TEMPLATE_ID'
)

if response.error?
  puts "Error deleting template: #{response.error.message}"
else
  puts "Template deleted successfully"
end
```

## Template Best Practices

### 1. Clear and Concise

```ruby
# Good: Clear and specific
"Hi {{1}}, your order #{{2}} has been shipped and will arrive by {{3}}."

# Avoid: Too generic
"Hello, your item has been processed."
```

### 2. Use Parameters Wisely

```ruby
# Good: Personalized with specific details
"Hi {{1}}, your {{2}} appointment on {{3}} has been confirmed."

# Avoid: Too many parameters
"Hi {{1}}, your {{2}} for {{3}} on {{4}} at {{5}} with {{6}} has been {{7}}."
```

### 3. Include Call-to-Action

```ruby
components_json = [
  {
    type: 'BODY',
    text: 'Your order is ready for pickup! Store hours: 9 AM - 6 PM'
  },
  {
    type: 'BUTTONS',
    buttons: [
      {
        type: 'QUICK_REPLY',
        text: 'On my way'
      },
      {
        type: 'QUICK_REPLY',
        text: 'Pick up tomorrow'
      }
    ]
  }
]
```

## Template Status and Approval

Templates go through an approval process:

- **PENDING**: Submitted for review
- **APPROVED**: Ready to use
- **REJECTED**: Needs modifications
- **DISABLED**: Temporarily disabled

```ruby
# Check template status
response = client.templates.list(business_id: 'YOUR_BUSINESS_ID')

response.data.each do |template|
  case template.status
  when 'APPROVED'
    puts "✅ #{template.name} is ready to use"
  when 'PENDING'
    puts "⏳ #{template.name} is under review"
  when 'REJECTED'
    puts "❌ #{template.name} was rejected: #{template.rejection_reason}"
  when 'DISABLED'
    puts "🚫 #{template.name} is disabled"
  end
end
```

## Common Template Examples

### Order Confirmation

```ruby
{
  type: 'BODY',
  text: 'Hi {{1}}! Your order #{{2}} for {{3}} items totaling {{4}} has been confirmed. Estimated delivery: {{5}}.'
}
```

### Appointment Reminder

```ruby
{
  type: 'BODY',
  text: 'Hi {{1}}, this is a reminder that you have a {{2}} appointment scheduled for {{3}} at {{4}}. Please reply CONFIRM to confirm.'
}
```

### OTP Verification

```ruby
{
  type: 'BODY',
  text: 'Your verification code is: {{1}}. This code will expire in 10 minutes. Do not share this code with anyone.'
}
```

## Error Handling

```ruby
response = client.templates.create(
  business_id: 'YOUR_BUSINESS_ID',
  name: 'my_template',
  language: 'en_US',
  category: 'TRANSACTIONAL',
  components_json: components_json
)

if response.error?
  case response.error.code
  when 100 # Invalid parameter
    puts "Template format error: #{response.error.message}"
  when 200 # Permissions error
    puts "Permission denied: Check your business verification status"
  else
    puts "Error: #{response.error.message}"
  end
else
  puts "Template created: #{response.data.id}"
end
```

## Next Steps

- [Messages API](./messages.md) - Learn how to send template messages
- [Business Profile API](./business-profile.md) - Manage your business information
- [Examples](../examples.md) - See template examples in practice