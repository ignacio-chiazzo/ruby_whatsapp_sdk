---
sidebar_position: 2
---

# Media API

The Media API allows you to upload, download, retrieve, and delete media files for use with WhatsApp messages.

## Supported Media Types

WhatsApp supports the following media types:

- **Images**: JPEG, PNG, WEBP (max 5MB)
- **Audio**: AAC, M4A, MP3, OGG (max 16MB)
- **Video**: MP4, 3GPP (max 16MB)
- **Documents**: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX (max 100MB)
- **Stickers**: WEBP (max 100KB)

## Upload Media

Upload a media file to WhatsApp servers:

```ruby
# Upload an image
response = client.media.upload(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  file_path: 'path/to/image.jpg',
  type: 'image/jpeg'
)

if response.error?
  puts "Upload failed: #{response.error.message}"
else
  puts "Media uploaded successfully! ID: #{response.data.id}"
  media_id = response.data.id
end
```

### Upload Different Media Types

```ruby
# Upload audio
client.media.upload(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  file_path: 'path/to/audio.mp3',
  type: 'audio/mpeg'
)

# Upload video
client.media.upload(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  file_path: 'path/to/video.mp4',
  type: 'video/mp4'
)

# Upload document
client.media.upload(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  file_path: 'path/to/document.pdf',
  type: 'application/pdf'
)

# Upload sticker
client.media.upload(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  file_path: 'path/to/sticker.webp',
  type: 'image/webp'
)
```

## Get Media Information

Retrieve metadata about an uploaded media file:

```ruby
response = client.media.get(media_id: 'MEDIA_ID')

if response.error?
  puts "Error retrieving media: #{response.error.message}"
else
  media = response.data
  puts "Media URL: #{media.url}"
  puts "Media type: #{media.mime_type}"
  puts "File size: #{media.file_size} bytes"
end
```

## Download Media

Download a media file from WhatsApp servers:

```ruby
# First, get the media information to obtain the download URL
media_response = client.media.get(media_id: 'MEDIA_ID')

if media_response.error?
  puts "Error getting media info: #{media_response.error.message}"
else
  # Download the media file
  download_response = client.media.download(
    url: media_response.data.url,
    file_path: 'downloads/downloaded_file.jpg',
    media_type: 'image/jpeg'
  )

  if download_response.error?
    puts "Download failed: #{download_response.error.message}"
  else
    puts "Media downloaded successfully to: downloads/downloaded_file.jpg"
  end
end
```

### Download with Authentication

The download method automatically handles authentication headers:

```ruby
# The SDK automatically includes the authorization header
client.media.download(
  url: 'https://lookaside.fbsbx.com/whatsapp_business/attachments/media_id',
  file_path: 'local/path/to/save/file.jpg',
  media_type: 'image/jpeg'
)
```

## Delete Media

Remove a media file from WhatsApp servers:

```ruby
response = client.media.delete(media_id: 'MEDIA_ID')

if response.error?
  puts "Error deleting media: #{response.error.message}"
else
  puts "Media deleted successfully"
end
```

## Complete Workflow Example

Here's a complete example of uploading media and sending it in a message:

```ruby
# 1. Upload media
upload_response = client.media.upload(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  file_path: 'assets/product_image.jpg',
  type: 'image/jpeg'
)

if upload_response.error?
  puts "Upload failed: #{upload_response.error.message}"
  exit
end

media_id = upload_response.data.id
puts "Media uploaded with ID: #{media_id}"

# 2. Send the media in a message
message_response = client.messages.send_image(
  sender_id: 'YOUR_PHONE_NUMBER_ID',
  recipient_number: '1234567890',
  image_id: media_id,
  caption: 'Check out our new product!'
)

if message_response.error?
  puts "Message send failed: #{message_response.error.message}"
else
  puts "Message sent successfully!"
end

# 3. Clean up - delete the media file (optional)
# Note: You may want to keep media files for reuse
delete_response = client.media.delete(media_id: media_id)
if delete_response.error?
  puts "Warning: Could not delete media: #{delete_response.error.message}"
else
  puts "Media file cleaned up"
end
```

## Best Practices

### File Size and Format

1. **Optimize file sizes**: Compress images and videos to reduce upload time and storage costs
2. **Use appropriate formats**: Stick to supported formats for best compatibility
3. **Consider mobile users**: Large files may take time to download on mobile connections

### Error Handling

Always check for errors when working with media:

```ruby
def upload_and_send_image(file_path, recipient)
  # Upload with error handling
  upload_response = client.media.upload(
    sender_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
    file_path: file_path,
    type: MIME::Types.type_for(file_path).first.content_type
  )

  if upload_response.error?
    logger.error "Failed to upload #{file_path}: #{upload_response.error.message}"
    return false
  end

  # Send with error handling
  message_response = client.messages.send_image(
    sender_id: ENV['WHATSAPP_PHONE_NUMBER_ID'],
    recipient_number: recipient,
    image_id: upload_response.data.id
  )

  if message_response.error?
    logger.error "Failed to send message: #{message_response.error.message}"
    return false
  end

  true
end
```

### Media Management

1. **Reuse media**: Uploaded media can be reused multiple times
2. **Clean up**: Delete unused media to save storage
3. **Cache media IDs**: Store media IDs in your database for reuse

## Common Errors

### Upload Errors

- **File too large**: Check file size limits for each media type
- **Unsupported format**: Ensure you're using supported MIME types
- **File not found**: Verify the file path exists and is readable

### Download Errors

- **Invalid URL**: The media URL may have expired
- **Permission denied**: Ensure proper authentication headers
- **Network issues**: Handle timeouts and network failures gracefully

## Next Steps

- [Messages API](./messages.md) - Learn how to send media messages
- [Templates API](./templates.md) - Use media in message templates
- [Examples](../examples.md) - See practical media handling examples