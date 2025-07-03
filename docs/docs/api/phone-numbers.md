---
sidebar_position: 4
---

# Phone Numbers API

The Phone Numbers API allows you to manage WhatsApp Business phone numbers, including registration, retrieval, and deregistration.

## Overview

Phone numbers are the endpoints that send and receive WhatsApp messages. Each phone number must be registered with WhatsApp Business API before it can be used.

## List Phone Numbers

Get all phone numbers associated with your business:

```ruby
response = client.phone_numbers.list(business_id: 'YOUR_BUSINESS_ID')

if response.error?
  puts "Error: #{response.error.message}"
else
  phone_numbers = response.data
  phone_numbers.each do |phone_number|
    puts "Phone Number: #{phone_number.display_phone_number}"
    puts "ID: #{phone_number.id}"
    puts "Status: #{phone_number.status}"
    puts "Quality Rating: #{phone_number.quality_rating}"
    puts "---"
  end
end
```

## Get Phone Number Details

Retrieve detailed information about a specific phone number:

```ruby
response = client.phone_numbers.get(phone_number_id: 'PHONE_NUMBER_ID')

if response.error?
  puts "Error: #{response.error.message}"
else
  phone_number = response.data
  puts "Display Phone Number: #{phone_number.display_phone_number}"
  puts "Verified Name: #{phone_number.verified_name}"
  puts "Status: #{phone_number.status}"
  puts "Quality Rating: #{phone_number.quality_rating}"
  puts "Messaging Limit: #{phone_number.messaging_limit_tier}"
  puts "Certificate: #{phone_number.certificate}"
end
```

## Register Phone Number

Register a phone number with WhatsApp Business API:

```ruby
response = client.phone_numbers.register_number(
  phone_number_id: 'PHONE_NUMBER_ID',
  pin: '123456' # 6-digit PIN received via SMS or voice call
)

if response.error?
  puts "Registration failed: #{response.error.message}"
else
  puts "Phone number registered successfully!"
end
```

### Registration Process

1. **Request verification code**: WhatsApp sends a 6-digit PIN via SMS or voice call
2. **Call register_number**: Use the PIN to complete registration
3. **Verification**: The number becomes active for sending messages

```ruby
# Complete registration flow
def register_whatsapp_number(phone_number_id)
  puts "A 6-digit PIN has been sent to your phone number."
  print "Enter the PIN: "
  pin = gets.chomp

  response = client.phone_numbers.register_number(
    phone_number_id: phone_number_id,
    pin: pin
  )

  if response.error?
    puts "Registration failed: #{response.error.message}"
    false
  else
    puts "✅ Phone number registered successfully!"
    true
  end
end
```

## Deregister Phone Number

Remove a phone number from WhatsApp Business API:

```ruby
response = client.phone_numbers.deregister_number(
  phone_number_id: 'PHONE_NUMBER_ID'
)

if response.error?
  puts "Deregistration failed: #{response.error.message}"
else
  puts "Phone number deregistered successfully"
end
```

**Warning**: Deregistering a phone number will:
- Stop all message sending/receiving
- Remove the number from your business account
- Require re-registration to use again

## Phone Number Status

Phone numbers can have different statuses:

- **VERIFIED**: Ready to send and receive messages
- **UNVERIFIED**: Needs registration/verification
- **MIGRATED**: Migrated from WhatsApp Business App
- **BANNED**: Temporarily or permanently banned
- **RESTRICTED**: Limited functionality due to policy violations

```ruby
def check_phone_number_status(phone_number_id)
  response = client.phone_numbers.get(phone_number_id: phone_number_id)
  
  if response.error?
    puts "Error checking status: #{response.error.message}"
    return
  end

  phone_number = response.data
  
  case phone_number.status
  when 'VERIFIED'
    puts "✅ Phone number is ready to use"
  when 'UNVERIFIED'
    puts "⚠️ Phone number needs verification"
  when 'MIGRATED'
    puts "📱 Phone number was migrated from WhatsApp Business App"
  when 'BANNED'
    puts "🚫 Phone number is banned"
  when 'RESTRICTED'
    puts "⚠️ Phone number has restrictions"
  else
    puts "❓ Unknown status: #{phone_number.status}"
  end
end
```

## Quality Rating

WhatsApp assigns quality ratings based on user feedback and messaging patterns:

- **GREEN**: High quality, can send messages to many users
- **YELLOW**: Medium quality, has some messaging limits
- **RED**: Low quality, significant messaging restrictions
- **UNKNOWN**: Insufficient data to determine quality

```ruby
def check_quality_rating(phone_number_id)
  response = client.phone_numbers.get(phone_number_id: phone_number_id)
  
  if response.error?
    puts "Error: #{response.error.message}"
    return
  end

  phone_number = response.data
  
  case phone_number.quality_rating
  when 'GREEN'
    puts "🟢 Excellent quality rating"
  when 'YELLOW'
    puts "🟡 Good quality rating - monitor messaging practices"
  when 'RED'
    puts "🔴 Poor quality rating - review messaging guidelines"
  when 'UNKNOWN'
    puts "⚪ Quality rating not yet determined"
  end
  
  puts "Messaging limit tier: #{phone_number.messaging_limit_tier}"
end
```

## Messaging Limits

WhatsApp enforces messaging limits based on phone number quality:

```ruby
def get_messaging_limits(phone_number_id)
  response = client.phone_numbers.get(phone_number_id: phone_number_id)
  
  if response.error?
    puts "Error: #{response.error.message}"
    return
  end

  phone_number = response.data
  
  puts "Current messaging limit tier: #{phone_number.messaging_limit_tier}"
  
  case phone_number.messaging_limit_tier
  when 'TIER_50'
    puts "Can send up to 50 messages per day"
  when 'TIER_250'
    puts "Can send up to 250 messages per day"
  when 'TIER_1K'
    puts "Can send up to 1,000 messages per day"
  when 'TIER_10K'
    puts "Can send up to 10,000 messages per day"
  when 'TIER_100K'
    puts "Can send up to 100,000 messages per day"
  when 'TIER_UNLIMITED'
    puts "No daily messaging limit"
  end
end
```

## Best Practices

### 1. Monitor Quality Rating

```ruby
def monitor_phone_number_health(phone_number_id)
  response = client.phone_numbers.get(phone_number_id: phone_number_id)
  
  return if response.error?
  
  phone_number = response.data
  
  # Alert if quality rating drops
  if phone_number.quality_rating == 'RED'
    send_alert("Phone number #{phone_number_id} has RED quality rating!")
  elsif phone_number.quality_rating == 'YELLOW'
    send_warning("Phone number #{phone_number_id} has YELLOW quality rating")
  end
  
  # Log current status
  Rails.logger.info "Phone #{phone_number_id}: " \
    "Quality=#{phone_number.quality_rating}, " \
    "Limit=#{phone_number.messaging_limit_tier}"
end
```

### 2. Handle Registration Errors

```ruby
def safe_register_number(phone_number_id, pin)
  response = client.phone_numbers.register_number(
    phone_number_id: phone_number_id,
    pin: pin
  )

  if response.error?
    case response.error.code
    when 1357045 # Invalid PIN
      puts "Invalid PIN. Please check and try again."
    when 1357046 # PIN expired
      puts "PIN expired. Please request a new one."
    when 1357047 # Too many attempts
      puts "Too many attempts. Please wait before trying again."
    else
      puts "Registration error: #{response.error.message}"
    end
    false
  else
    puts "Registration successful!"
    true
  end
end
```

### 3. Regular Health Checks

```ruby
class PhoneNumberHealthCheck
  def initialize
    @client = WhatsappSdk::Api::Client.new
  end

  def check_all_numbers(business_id)
    response = @client.phone_numbers.list(business_id: business_id)
    
    return if response.error?
    
    response.data.each do |phone_number|
      check_individual_number(phone_number)
    end
  end

  private

  def check_individual_number(phone_number)
    issues = []
    
    # Check status
    issues << "Not verified" unless phone_number.status == 'VERIFIED'
    
    # Check quality rating
    issues << "Poor quality rating" if phone_number.quality_rating == 'RED'
    issues << "Medium quality rating" if phone_number.quality_rating == 'YELLOW'
    
    # Check messaging limits
    if phone_number.messaging_limit_tier == 'TIER_50'
      issues << "Limited to 50 messages per day"
    end
    
    if issues.any?
      puts "⚠️ #{phone_number.display_phone_number}: #{issues.join(', ')}"
    else
      puts "✅ #{phone_number.display_phone_number}: All good"
    end
  end
end

# Usage
health_check = PhoneNumberHealthCheck.new
health_check.check_all_numbers(ENV['WHATSAPP_BUSINESS_ID'])
```

## Certificate Information

Get SSL certificate information for your phone number:

```ruby
response = client.phone_numbers.get(phone_number_id: 'PHONE_NUMBER_ID')

if response.error?
  puts "Error: #{response.error.message}"
else
  phone_number = response.data
  
  if phone_number.certificate
    puts "Certificate: #{phone_number.certificate}"
    puts "Certificate available for webhook verification"
  else
    puts "No certificate information available"
  end
end
```

## Webhook Integration

Use phone number information in webhook processing:

```ruby
class WhatsappWebhookController < ApplicationController
  def receive
    # Verify the webhook is for a known phone number
    phone_number_id = params[:entry]&.first&.dig(:id)
    
    unless valid_phone_number?(phone_number_id)
      render json: { error: 'Unknown phone number' }, status: 400
      return
    end
    
    # Process the webhook
    process_webhook_data(params)
    render json: { status: 'ok' }
  end

  private

  def valid_phone_number?(phone_number_id)
    response = whatsapp_client.phone_numbers.get(
      phone_number_id: phone_number_id
    )
    
    !response.error? && response.data.status == 'VERIFIED'
  end

  def whatsapp_client
    @whatsapp_client ||= WhatsappSdk::Api::Client.new
  end
end
```

## Error Handling

```ruby
def handle_phone_number_errors(response)
  return unless response.error?

  case response.error.code
  when 100 # Invalid parameter
    puts "Invalid phone number ID or parameter"
  when 200 # Permissions error
    puts "Insufficient permissions to access phone number"
  when 1357045 # Invalid verification PIN
    puts "Invalid verification PIN"
  when 1357046 # PIN expired
    puts "Verification PIN has expired"
  when 1357047 # Too many verification attempts
    puts "Too many verification attempts - please wait"
  else
    puts "Error #{response.error.code}: #{response.error.message}"
  end
end
```

## Next Steps

- [Messages API](./messages.md) - Start sending messages with your registered number
- [Business Profile API](./business-profile.md) - Set up your business profile
- [Examples](../examples.md) - See phone number management examples