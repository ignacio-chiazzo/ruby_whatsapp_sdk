---
sidebar_position: 5
---

# Examples

Practical examples of using the Ruby WhatsApp SDK in real-world scenarios.

## Basic Examples

### Simple Text Message

```ruby
require 'whatsapp_sdk'

# Configure the client
WhatsappSdk.configure do |config|
  config.access_token = ENV['WHATSAPP_ACCESS_TOKEN']
end

client = WhatsappSdk::Api::Client.new

# Send a text message
response = client.messages.send_text(
  sender_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
  recipient_number: '1234567890',
  message: 'Hello from Ruby WhatsApp SDK!'
)

if response.error?
  puts "Error: #{response.error.message}"
else
  puts "Message sent! ID: #{response.data.id}"
end
```

### Sending Images with Caption

```ruby
# Upload and send an image
upload_response = client.media.upload(
  sender_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
  file_path: 'assets/product.jpg',
  type: 'image/jpeg'
)

if upload_response.error?
  puts "Upload failed: #{upload_response.error.message}"
else
  # Send the uploaded image
  response = client.messages.send_image(
    sender_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
    recipient_number: '1234567890',
    image_id: upload_response.data.id,
    caption: '🎉 Check out our new product!'
  )
  
  puts response.error? ? "Error: #{response.error.message}" : "Image sent!"
end
```

## Rails Integration Examples

### Rails Service Class

```ruby
# app/services/whatsapp_service.rb
class WhatsappService
  def initialize
    @client = WhatsappSdk::Api::Client.new
    @phone_number_id = ENV['WHATSAPP_PHONE_NUMBER_ID']
  end

  def send_welcome_message(user)
    response = @client.messages.send_text(
      sender_id: @phone_number_id,
      recipient_number: user.phone_number,
      message: "Welcome to our service, #{user.name}! 👋"
    )

    log_message_result(response, user, 'welcome')
  end

  def send_order_confirmation(order)
    message = build_order_message(order)
    
    response = @client.messages.send_text(
      sender_id: @phone_number_id,
      recipient_number: order.customer.phone_number,
      message: message
    )

    log_message_result(response, order.customer, 'order_confirmation')
  end

  def send_media_message(user, media_path, caption = nil)
    # Upload media
    upload_response = @client.media.upload(
      sender_id: @phone_number_id,
      file_path: media_path,
      type: detect_mime_type(media_path)
    )

    return handle_error(upload_response) if upload_response.error?

    # Send based on media type
    case File.extname(media_path).downcase
    when '.jpg', '.jpeg', '.png', '.webp'
      send_image_message(user, upload_response.data.id, caption)
    when '.mp3', '.m4a', '.ogg'
      send_audio_message(user, upload_response.data.id)
    when '.mp4', '.3gp'
      send_video_message(user, upload_response.data.id, caption)
    else
      send_document_message(user, upload_response.data.id, caption)
    end
  end

  private

  def build_order_message(order)
    <<~MESSAGE
      🛍️ Order Confirmation ##{order.id}
      
      Items:
      #{order.items.map { |item| "• #{item.name} - $#{item.price}" }.join("\n")}
      
      Total: $#{order.total}
      
      We'll notify you when your order ships!
    MESSAGE
  end

  def send_image_message(user, media_id, caption)
    @client.messages.send_image(
      sender_id: @phone_number_id,
      recipient_number: user.phone_number,
      image_id: media_id,
      caption: caption
    )
  end

  def detect_mime_type(file_path)
    case File.extname(file_path).downcase
    when '.jpg', '.jpeg' then 'image/jpeg'
    when '.png' then 'image/png'
    when '.webp' then 'image/webp'
    when '.mp3' then 'audio/mpeg'
    when '.m4a' then 'audio/mp4'
    when '.ogg' then 'audio/ogg'
    when '.mp4' then 'video/mp4'
    when '.pdf' then 'application/pdf'
    else 'application/octet-stream'
    end
  end

  def log_message_result(response, user, message_type)
    if response.error?
      Rails.logger.error "Failed to send #{message_type} to #{user.phone_number}: #{response.error.message}"
      false
    else
      Rails.logger.info "Sent #{message_type} to #{user.phone_number}, message ID: #{response.data.id}"
      true
    end
  end

  def handle_error(response)
    Rails.logger.error "WhatsApp API error: #{response.error.message}"
    false
  end
end
```

### Background Job for Bulk Messages

```ruby
# app/jobs/whatsapp_broadcast_job.rb
class WhatsappBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message_text, user_ids)
    whatsapp_service = WhatsappService.new
    users = User.where(id: user_ids, phone_number: true)

    users.find_each do |user|
      begin
        whatsapp_service.send_text_message(user, message_text)
        sleep(1) # Rate limiting - adjust based on your needs
      rescue => e
        Rails.logger.error "Failed to send message to user #{user.id}: #{e.message}"
      end
    end
  end
end

# Usage
WhatsappBroadcastJob.perform_later(
  "🎉 Flash sale! 50% off all items today only!",
  User.subscribed.pluck(:id)
)
```

## Interactive Message Examples

### Customer Support Bot

```ruby
class CustomerSupportBot
  def initialize
    @client = WhatsappSdk::Api::Client.new
    @phone_number_id = ENV['WHATSAPP_PHONE_NUMBER_ID']
  end

  def send_support_menu(customer_phone)
    header = WhatsappSdk::Resource::InteractiveHeader.new(
      type: 'text',
      text: '🛠️ Customer Support'
    )

    body = WhatsappSdk::Resource::InteractiveBody.new(
      text: 'How can we help you today?'
    )

    footer = WhatsappSdk::Resource::InteractiveFooter.new(
      text: 'Select an option below'
    )

    action = WhatsappSdk::Resource::InteractiveAction.new(type: 'list_message')
    action.button = 'Support Options'

    # Create support sections
    billing_section = WhatsappSdk::Resource::InteractiveActionSection.new(
      title: 'Billing & Payments'
    )
    billing_section.add_row(WhatsappSdk::Resource::InteractiveActionSectionRow.new(
      title: 'Payment Issues',
      id: 'billing_payment',
      description: 'Problems with payments or billing'
    ))
    billing_section.add_row(WhatsappSdk::Resource::InteractiveActionSectionRow.new(
      title: 'Refund Request',
      id: 'billing_refund',
      description: 'Request a refund'
    ))

    technical_section = WhatsappSdk::Resource::InteractiveActionSection.new(
      title: 'Technical Support'
    )
    technical_section.add_row(WhatsappSdk::Resource::InteractiveActionSectionRow.new(
      title: 'App Issues',
      id: 'tech_app',
      description: 'App not working properly'
    ))
    technical_section.add_row(WhatsappSdk::Resource::InteractiveActionSectionRow.new(
      title: 'Account Access',
      id: 'tech_account',
      description: 'Cannot access my account'
    ))

    action.add_section(billing_section)
    action.add_section(technical_section)

    interactive = WhatsappSdk::Resource::Interactive.new(
      type: 'list',
      header: header,
      body: body,
      footer: footer,
      action: action
    )

    @client.messages.send_interactive_list_messages(
      sender_id: @phone_number_id,
      recipient_number: customer_phone,
      interactive: interactive
    )
  end

  def send_quick_responses(customer_phone, question)
    header = WhatsappSdk::Resource::InteractiveHeader.new(
      type: 'text',
      text: question
    )

    body = WhatsappSdk::Resource::InteractiveBody.new(
      text: 'Please choose:'
    )

    action = WhatsappSdk::Resource::InteractiveAction.new(type: 'reply_button')
    action.add_reply_button(WhatsappSdk::Resource::InteractiveActionReplyButton.new(
      title: 'Yes',
      id: 'yes'
    ))
    action.add_reply_button(WhatsappSdk::Resource::InteractiveActionReplyButton.new(
      title: 'No',
      id: 'no'
    ))
    action.add_reply_button(WhatsappSdk::Resource::InteractiveActionReplyButton.new(
      title: 'Need Help',
      id: 'help'
    ))

    interactive = WhatsappSdk::Resource::Interactive.new(
      type: 'reply_button',
      header: header,
      body: body,
      action: action
    )

    @client.messages.send_interactive_reply_buttons(
      sender_id: @phone_number_id,
      recipient_number: customer_phone,
      interactive: interactive
    )
  end
end
```

### E-commerce Order Status

```ruby
class OrderNotificationService
  def initialize
    @client = WhatsappSdk::Api::Client.new
    @phone_number_id = ENV['WHATSAPP_PHONE_NUMBER_ID']
  end

  def send_order_status(order)
    case order.status
    when 'confirmed'
      send_order_confirmed(order)
    when 'shipped'
      send_order_shipped(order)
    when 'delivered'
      send_order_delivered(order)
    end
  end

  private

  def send_order_confirmed(order)
    message = <<~TEXT
      ✅ Order Confirmed!
      
      Order ##{order.id}
      #{order.items.count} items - $#{order.total}
      
      Estimated delivery: #{order.estimated_delivery.strftime('%B %d, %Y')}
      
      We'll keep you updated on your order status.
    TEXT

    @client.messages.send_text(
      sender_id: @phone_number_id,
      recipient_number: order.customer.phone_number,
      message: message
    )
  end

  def send_order_shipped(order)
    message = <<~TEXT
      📦 Your order has shipped!
      
      Order ##{order.id}
      Tracking: #{order.tracking_number}
      
      Track your package: #{order.tracking_url}
      
      Expected delivery: #{order.estimated_delivery.strftime('%B %d, %Y')}
    TEXT

    @client.messages.send_text(
      sender_id: @phone_number_id,
      recipient_number: order.customer.phone_number,
      message: message
    )
  end

  def send_order_delivered(order)
    header = WhatsappSdk::Resource::InteractiveHeader.new(
      type: 'text',
      text: '📦 Package Delivered!'
    )

    body = WhatsappSdk::Resource::InteractiveBody.new(
      text: "Your order ##{order.id} has been delivered. How was your experience?"
    )

    action = WhatsappSdk::Resource::InteractiveAction.new(type: 'reply_button')
    action.add_reply_button(WhatsappSdk::Resource::InteractiveActionReplyButton.new(
      title: '⭐⭐⭐⭐⭐',
      id: 'rating_5'
    ))
    action.add_reply_button(WhatsappSdk::Resource::InteractiveActionReplyButton.new(
      title: '⭐⭐⭐⭐',
      id: 'rating_4'
    ))
    action.add_reply_button(WhatsappSdk::Resource::InteractiveActionReplyButton.new(
      title: 'Issue',
      id: 'rating_issue'
    ))

    interactive = WhatsappSdk::Resource::Interactive.new(
      type: 'reply_button',
      header: header,
      body: body,
      action: action
    )

    @client.messages.send_interactive_reply_buttons(
      sender_id: @phone_number_id,
      recipient_number: order.customer.phone_number,
      interactive: interactive
    )
  end
end
```

## Template Message Examples

### Appointment Reminder

```ruby
def send_appointment_reminder(appointment)
  # Template: "Hi {{1}}, your {{2}} appointment is scheduled for {{3}} at {{4}}. Please reply CONFIRM to confirm."
  
  components = [
    WhatsappSdk::Resource::Component.new(
      type: 'body',
      parameters: [
        WhatsappSdk::Resource::ParameterObject.new(
          type: 'text',
          text: appointment.customer.name
        ),
        WhatsappSdk::Resource::ParameterObject.new(
          type: 'text',
          text: appointment.service_type
        ),
        WhatsappSdk::Resource::ParameterObject.new(
          type: 'text',
          text: appointment.date.strftime('%B %d, %Y')
        ),
        WhatsappSdk::Resource::ParameterObject.new(
          type: 'text',
          text: appointment.time.strftime('%I:%M %p')
        )
      ]
    )
  ]

  client.messages.send_template(
    sender_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
    recipient_number: appointment.customer.phone_number,
    name: 'appointment_reminder',
    language: 'en_US',
    components: components
  )
end
```

### Marketing Campaign with Media

```ruby
def send_promotion_template(customer, product)
  # Upload product image
  upload_response = client.media.upload(
    sender_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
    file_path: product.image_path,
    type: 'image/jpeg'
  )

  return if upload_response.error?

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
          text: customer.name
        ),
        WhatsappSdk::Resource::ParameterObject.new(
          type: 'text',
          text: product.name
        ),
        WhatsappSdk::Resource::ParameterObject.new(
          type: 'text',
          text: product.discount_percentage.to_s
        )
      ]
    )
  ]

  client.messages.send_template(
    sender_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
    recipient_number: customer.phone_number,
    name: 'product_promotion',
    language: 'en_US',
    components: components
  )
end
```

## Error Handling Examples

### Robust Message Sending

```ruby
class RobustWhatsappSender
  MAX_RETRIES = 3
  RETRY_DELAY = 2

  def initialize
    @client = WhatsappSdk::Api::Client.new
    @phone_number_id = ENV['WHATSAPP_PHONE_NUMBER_ID']
  end

  def send_message_with_retry(recipient, message, retries = 0)
    response = @client.messages.send_text(
      sender_id: @phone_number_id,
      recipient_number: recipient,
      message: message
    )

    if response.error?
      handle_error(response, recipient, message, retries)
    else
      log_success(recipient, response.data.id)
      true
    end
  rescue => e
    handle_exception(e, recipient, message, retries)
  end

  private

  def handle_error(response, recipient, message, retries)
    error_code = response.error.code
    error_message = response.error.message

    case error_code
    when 131026 # Message undeliverable
      Rails.logger.error "Message undeliverable to #{recipient}: #{error_message}"
      false
    when 131047 # Re-engagement message
      Rails.logger.warn "Re-engagement required for #{recipient}"
      send_template_message(recipient) # Send approved template instead
    when 131048 # Rate limited
      if retries < MAX_RETRIES
        Rails.logger.warn "Rate limited, retrying in #{RETRY_DELAY}s"
        sleep(RETRY_DELAY)
        send_message_with_retry(recipient, message, retries + 1)
      else
        Rails.logger.error "Rate limited, max retries exceeded for #{recipient}"
        false
      end
    else
      if retries < MAX_RETRIES
        Rails.logger.warn "Error #{error_code}, retrying: #{error_message}"
        sleep(RETRY_DELAY)
        send_message_with_retry(recipient, message, retries + 1)
      else
        Rails.logger.error "Max retries exceeded for #{recipient}: #{error_message}"
        false
      end
    end
  end

  def handle_exception(exception, recipient, message, retries)
    if retries < MAX_RETRIES
      Rails.logger.warn "Exception occurred, retrying: #{exception.message}"
      sleep(RETRY_DELAY)
      send_message_with_retry(recipient, message, retries + 1)
    else
      Rails.logger.error "Max retries exceeded due to exception for #{recipient}: #{exception.message}"
      false
    end
  end

  def log_success(recipient, message_id)
    Rails.logger.info "Message sent successfully to #{recipient}, ID: #{message_id}"
  end

  def send_template_message(recipient)
    # Send a pre-approved template message for re-engagement
    @client.messages.send_template(
      sender_id: @phone_number_id,
      recipient_number: recipient,
      name: 'hello_world',
      language: 'en_US'
    )
  end
end
```

## Testing Examples

### RSpec Testing

```ruby
# spec/services/whatsapp_service_spec.rb
RSpec.describe WhatsappService do
  let(:service) { described_class.new }
  let(:client) { instance_double(WhatsappSdk::Api::Client) }
  let(:messages_api) { instance_double(WhatsappSdk::Api::Messages) }

  before do
    allow(WhatsappSdk::Api::Client).to receive(:new).and_return(client)
    allow(client).to receive(:messages).and_return(messages_api)
  end

  describe '#send_welcome_message' do
    let(:user) { create(:user, name: 'John', phone_number: '1234567890') }
    
    it 'sends a welcome message' do
      response = instance_double(
        WhatsappSdk::Api::Responses::MessageDataResponse,
        error?: false,
        data: double(id: 'msg_123')
      )
      
      expect(messages_api).to receive(:send_text).with(
        sender_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
        recipient_number: '1234567890',
        message: 'Welcome to our service, John! 👋'
      ).and_return(response)

      result = service.send_welcome_message(user)
      expect(result).to be true
    end

    it 'handles errors gracefully' do
      error_response = instance_double(
        WhatsappSdk::Api::Responses::MessageDataResponse,
        error?: true,
        error: double(message: 'Invalid phone number')
      )
      
      expect(messages_api).to receive(:send_text).and_return(error_response)

      result = service.send_welcome_message(user)
      expect(result).to be false
    end
  end
end
```

## Next Steps

- [API Reference](./api/messages.md) - Explore all available methods
- [Configuration](./configuration.md) - Learn about advanced configuration options
- [Troubleshooting](./troubleshooting.md) - Solve common issues