---
sidebar_position: 6
---

# Troubleshooting

Common issues and solutions when using the Ruby WhatsApp SDK.

## Installation Issues

### Gem Installation Fails

**Problem**: `gem install whatsapp_sdk` fails with dependency errors.

**Solution**:
```bash
# Update gem system first
gem update --system

# Install bundler if not present
gem install bundler

# Try installing with bundle
echo 'gem "whatsapp_sdk"' > Gemfile
bundle install
```

### Version Conflicts

**Problem**: Conflicting gem versions in your application.

**Solution**:
```ruby
# In your Gemfile, specify exact versions
gem 'whatsapp_sdk', '~> 0.9.0'
gem 'faraday', '~> 2.0'

# Then run
bundle update whatsapp_sdk
```

## Authentication Issues

### Invalid Access Token

**Problem**: `401 Unauthorized` or `Invalid access token` errors.

**Solution**:
1. Verify your access token in Meta Business Manager
2. Check token hasn't expired
3. Ensure token has proper permissions

```ruby
# Test your token
client = WhatsappSdk::Api::Client.new('YOUR_ACCESS_TOKEN')
response = client.phone_numbers.list(business_id: 'YOUR_BUSINESS_ID')

if response.error?
  puts "Token issue: #{response.error.message}"
else
  puts "Token is valid"
end
```

### Insufficient Permissions

**Problem**: `200 Permissions error` when calling APIs.

**Solution**:
1. Verify your app has WhatsApp Business permissions
2. Check your access token includes required scopes:
   - `whatsapp_business_messaging`
   - `whatsapp_business_management`

## Message Sending Issues

### Message Not Delivered

**Problem**: API returns success but message isn't delivered.

**Possible Causes**:
1. **24-hour rule violation**: Can't send non-template messages to users who haven't messaged you in 24 hours
2. **Invalid phone number format**
3. **User blocked your business**
4. **User's WhatsApp version too old**

**Solutions**:
```ruby
# 1. Use template messages for users outside 24-hour window
client.messages.send_template(
  sender_id: 'SENDER_ID',
  recipient_number: 'RECIPIENT',
  name: 'hello_world',
  language: 'en_US'
)

# 2. Validate phone number format
def valid_phone_number?(number)
  # Remove all non-digits and check length
  clean_number = number.gsub(/\D/, '')
  clean_number.length >= 10 && clean_number.length <= 15
end

# 3. Check for common formatting issues
def format_phone_number(number)
  # Remove spaces, dashes, parentheses
  clean = number.gsub(/[\s\-\(\)]/, '')
  
  # Add country code if missing (example for US)
  clean = "1#{clean}" if clean.length == 10 && !clean.start_with?('1')
  
  clean
end
```

### Rate Limiting

**Problem**: `131048 Rate limited` errors.

**Solution**:
```ruby
class RateLimitedSender
  def initialize
    @client = WhatsappSdk::Api::Client.new
    @last_send_time = Time.now
    @min_interval = 1.0 # 1 second between messages
  end

  def send_with_rate_limiting(sender_id, recipient, message)
    # Ensure minimum interval between sends
    time_since_last = Time.now - @last_send_time
    if time_since_last < @min_interval
      sleep(@min_interval - time_since_last)
    end

    response = @client.messages.send_text(
      sender_id: sender_id,
      recipient_number: recipient,
      message: message
    )

    @last_send_time = Time.now

    if response.error? && response.error.code == 131048
      # Exponential backoff for rate limiting
      sleep(2)
      send_with_rate_limiting(sender_id, recipient, message)
    else
      response
    end
  end
end
```

### Template Message Errors

**Problem**: Template messages fail with various errors.

**Common Issues**:
```ruby
# 1. Template not approved
# Error: 132000 - Template does not exist or is not approved

# Solution: Check template status
response = client.templates.list(business_id: 'BUSINESS_ID')
response.data.each do |template|
  puts "#{template.name}: #{template.status}"
  if template.status == 'REJECTED'
    puts "Rejection reason: #{template.rejection_reason}"
  end
end

# 2. Wrong parameter count or type
# Error: 132001 - Number of parameters does not match

# Solution: Match template parameters exactly
def send_order_template(customer_name, order_id)
  components = [
    WhatsappSdk::Resource::Component.new(
      type: 'body',
      parameters: [
        WhatsappSdk::Resource::ParameterObject.new(type: 'text', text: customer_name),
        WhatsappSdk::Resource::ParameterObject.new(type: 'text', text: order_id)
      ]
    )
  ]

  client.messages.send_template(
    sender_id: 'SENDER_ID',
    recipient_number: 'RECIPIENT',
    name: 'order_confirmation', # Template with 2 parameters: {{1}} {{2}}
    language: 'en_US',
    components: components
  )
end
```

## Media Upload Issues

### File Size Limits

**Problem**: Media upload fails due to file size.

**Solution**:
```ruby
def check_file_size(file_path, media_type)
  file_size = File.size(file_path)
  
  limits = {
    'image' => 5 * 1024 * 1024,      # 5MB
    'audio' => 16 * 1024 * 1024,     # 16MB
    'video' => 16 * 1024 * 1024,     # 16MB
    'document' => 100 * 1024 * 1024  # 100MB
  }
  
  type = media_type.split('/').first
  max_size = limits[type]
  
  if file_size > max_size
    puts "File too large: #{file_size} bytes (max: #{max_size} bytes)"
    false
  else
    true
  end
end
```

### Unsupported File Formats

**Problem**: Upload fails with unsupported format error.

**Solution**:
```ruby
SUPPORTED_FORMATS = {
  'image' => %w[image/jpeg image/png image/webp],
  'audio' => %w[audio/aac audio/mp4 audio/mpeg audio/ogg],
  'video' => %w[video/mp4 video/3gpp],
  'document' => %w[
    application/pdf
    application/vnd.ms-powerpoint
    application/msword
    application/vnd.ms-excel
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/vnd.openxmlformats-officedocument.presentationml.presentation
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
  ]
}.freeze

def validate_file_format(file_path, mime_type)
  extension = File.extname(file_path).downcase
  media_type = mime_type.split('/').first
  
  unless SUPPORTED_FORMATS[media_type]&.include?(mime_type)
    puts "Unsupported format: #{mime_type}"
    puts "Supported formats for #{media_type}: #{SUPPORTED_FORMATS[media_type]}"
    return false
  end
  
  true
end
```

## Network and Connection Issues

### Timeout Errors

**Problem**: Requests timeout or fail with network errors.

**Solution**:
```ruby
# Configure custom timeouts
require 'faraday'

custom_client = WhatsappSdk::Api::Client.new(
  access_token: 'YOUR_TOKEN',
  faraday: Faraday.new do |builder|
    builder.options.timeout = 30        # 30 seconds total timeout
    builder.options.open_timeout = 10   # 10 seconds to establish connection
    builder.adapter Faraday.default_adapter
  end
)

# Retry wrapper for network issues
def with_retry(max_retries: 3, delay: 1)
  retries = 0
  begin
    yield
  rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
    retries += 1
    if retries <= max_retries
      puts "Network error, retrying in #{delay}s... (#{retries}/#{max_retries})"
      sleep(delay)
      delay *= 2 # Exponential backoff
      retry
    else
      raise e
    end
  end
end

# Usage
response = with_retry do
  client.messages.send_text(
    sender_id: 'SENDER_ID',
    recipient_number: 'RECIPIENT',
    message: 'Hello!'
  )
end
```

### SSL/TLS Issues

**Problem**: SSL certificate verification errors.

**Solution**:
```ruby
# For development only - never use in production
require 'faraday'

insecure_client = WhatsappSdk::Api::Client.new(
  access_token: 'YOUR_TOKEN',
  faraday: Faraday.new(ssl: { verify: false }) do |builder|
    builder.adapter Faraday.default_adapter
  end
)

# Better solution: Update CA certificates
# On Ubuntu/Debian:
# sudo apt-get update && sudo apt-get install ca-certificates

# On macOS with Homebrew:
# brew install ca-certificates
```

## Configuration Issues

### Environment Variables Not Loading

**Problem**: Environment variables are nil or empty.

**Solution**:
```ruby
# 1. Check if variables are set
required_vars = %w[
  WHATSAPP_ACCESS_TOKEN
  WHATSAPP_PHONE_NUMBER_ID
  WHATSAPP_BUSINESS_ID
]

missing_vars = required_vars.select { |var| ENV[var].nil? || ENV[var].empty? }

if missing_vars.any?
  puts "Missing environment variables: #{missing_vars.join(', ')}"
  exit 1
end

# 2. Use dotenv in development
# Add to Gemfile: gem 'dotenv-rails'
# Create .env file with your variables

# 3. Validate configuration on startup
def validate_whatsapp_config
  client = WhatsappSdk::Api::Client.new
  
  # Test connection
  response = client.phone_numbers.get(
    phone_number_id: ENV['WHATSAPP_PHONE_NUMBER_ID']
  )
  
  if response.error?
    puts "❌ WhatsApp configuration invalid: #{response.error.message}"
    exit 1
  else
    puts "✅ WhatsApp configuration valid"
  end
end
```

### Rails Integration Issues

**Problem**: SDK not working properly in Rails application.

**Solution**:
```ruby
# config/application.rb
require 'whatsapp_sdk'

# config/initializers/whatsapp_sdk.rb
WhatsappSdk.configure do |config|
  config.access_token = Rails.application.credentials.whatsapp[:access_token]
  config.logger = Rails.logger
  config.logger_options = { 
    bodies: Rails.env.development? # Only log bodies in development
  }
end

# Validate configuration in initializer
begin
  client = WhatsappSdk::Api::Client.new
  response = client.phone_numbers.get(
    phone_number_id: Rails.application.credentials.whatsapp[:phone_number_id]
  )
  
  unless response.error?
    Rails.logger.info "WhatsApp SDK configured successfully"
  else
    Rails.logger.error "WhatsApp SDK configuration error: #{response.error.message}"
  end
rescue => e
  Rails.logger.error "WhatsApp SDK initialization failed: #{e.message}"
end
```

## Debugging

### Enable Detailed Logging

```ruby
require 'logger'

# Create detailed logger
logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

client = WhatsappSdk::Api::Client.new(
  access_token: 'YOUR_TOKEN',
  logger: logger,
  logger_options: {
    headers: true,    # Log request/response headers
    bodies: true,     # Log request/response bodies
    log_level: :debug # Detailed logging
  }
)
```

### Inspect API Responses

```ruby
def debug_response(response)
  puts "Success: #{!response.error?}"
  
  if response.error?
    puts "Error Code: #{response.error.code}"
    puts "Error Message: #{response.error.message}"
    puts "Error Details: #{response.error.details}" if response.error.details
  else
    puts "Response Data: #{response.data.inspect}"
  end
  
  # Log HTTP details if available
  if response.respond_to?(:http_status)
    puts "HTTP Status: #{response.http_status}"
  end
end

# Usage
response = client.messages.send_text(...)
debug_response(response)
```

### Test API Connectivity

```ruby
def test_whatsapp_connectivity
  tests = [
    {
      name: "Phone Number Access",
      test: -> { client.phone_numbers.get(phone_number_id: ENV['WHATSAPP_PHONE_NUMBER_ID']) }
    },
    {
      name: "Business Profile Access",
      test: -> { client.business_profiles.get(phone_number_id: ENV['WHATSAPP_PHONE_NUMBER_ID']) }
    },
    {
      name: "Templates List",
      test: -> { client.templates.list(business_id: ENV['WHATSAPP_BUSINESS_ID']) }
    }
  ]

  tests.each do |test|
    print "Testing #{test[:name]}... "
    
    response = test[:test].call
    
    if response.error?
      puts "❌ Failed: #{response.error.message}"
    else
      puts "✅ Passed"
    end
  rescue => e
    puts "❌ Exception: #{e.message}"
  end
end

test_whatsapp_connectivity
```

## Common Error Codes

| Code | Description | Solution |
|------|-------------|----------|
| 100 | Invalid parameter | Check parameter format and values |
| 131026 | Message undeliverable | Verify phone number and user status |
| 131047 | Re-engagement message required | Send approved template message |
| 131048 | Rate limited | Implement rate limiting and retry logic |
| 132000 | Template not found/approved | Check template status and approval |
| 132001 | Parameter mismatch | Verify template parameters match exactly |
| 1357045 | Invalid PIN | Check PIN format for phone number registration |

## Getting Help

1. **Check Logs**: Enable detailed logging to see request/response details
2. **Meta Developer Documentation**: [WhatsApp Cloud API Docs](https://developers.facebook.com/docs/whatsapp/cloud-api)
3. **GitHub Issues**: [Ruby WhatsApp SDK Issues](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/issues)
4. **Meta Support**: Use Meta Business Support for account-specific issues
5. **Community**: Stack Overflow with `whatsapp-api` and `ruby` tags

## Next Steps

- [API Reference](./api/messages.md) - Detailed API documentation
- [Examples](./examples.md) - Working code examples
- [Configuration](./configuration.md) - Advanced configuration options