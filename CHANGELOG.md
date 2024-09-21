# Unreleased
- Increased minimum required Ruby version to 2.7.0

# v 0.13.0

- Remove sorbet dependency @ignacio-chiazzo [148](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/148) 
- Added the ability to specify the `filename` [via the document](https://developers.facebook.com/docs/whatsapp/cloud-api/reference/messages) API. @sahilas [#137](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/137)

# v 0.12.1
- Fix bug using `client/api_versions` @mgruner [#134](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/134)

# v 0.12.0
- Added ability to specify logger @chahmedejaz [#129](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/129)
- Allow download of unsupported media types @dvuckovic [#128](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/128)
- Allow users to specify the API version. @conr [#126](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/126)
- Use HTTP multipart only when needed. @ignacio-chiazzo [#123](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/123)
- Validate Vertical on BusinessProfile update API. @ignacio-chiazzo [#120](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/120)
- Added ability to specify fields param in the business profile API. @ignacio-chiazzo [#119](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/119)

# v 0.11.0
- Bumped API version to v19. @paulomcnally  https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/116

# v 0.10.0
- Implement Templates API @emersonu, @ignacio-chiazzo [#90](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/90)
- Using compatible Gem versions instead of fixed dependency versions @nbluis [#108](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/108)
- [Breaking Change] Rename `error` module with `errors`. @ignacio-chiazzo [#101](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/101)

If you are calling an error using `WhatsappSdk::Resource::Error`, you should update it to `WhatsappSdk::Resource::Errors`, e.g. `WhatsappSdk::Resource::Errors::MissingArgumentError`

# v 0.9.2
- Add Support to image/webp sticker media. @renatovico [#94](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/issues/94)

# v 0.9.1
- Invalidate unsupported and invalid media types @ignacio-chiazzo [#89](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/89)

# v 0.9.0
- Use binary mode to download files @ignacio-chiazzo [#88](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/87)
- Added support for downloading media by specifying the type @ignacio-chiazzo [#87](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/87)

# v 0.8.0
- Added Send interactive message @alienware [#82](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/82) 
- Support JRuby @ignacio-chiazzo [#83](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/83)
- Send interactive Reply Buttons Message @alienware [#79](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/79)

# v 0.7.3
- Added the ability to reply messages. @alienware [#77](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/77)

# v 0.7.2
- Added new fields to phone numbers API. @ignacio-chiazzo [#73](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/73)
- Upgraded API version to v16. @ignacio-chiazzo [#73](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/73)
- Make sorbet-runtime a runtime dependency. @ignacio-chiazzo [#70](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/70)

# v 0.7.1
Add Register API @andresyebra [#65](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/65)

# v 0.7.0
Add message reaction @sanchezpaco [#58](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/58)
Add Business update API @sahilbansal17 [#56](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/56)
Fix Sorbet bug BusinessAPI [#60](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/60)

# v 0.6.2
Add Business Profiles API @sahilbansal17 [#53](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/53)

# v 0.6.1
Add raw_response to response [#47](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/46)

# v 0.6.0
Fix issue on Linux when files are not sorted [#45](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/45)

# v 0.5.1
Remove warnings [#41](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/41)

# v 0.5.0
Require Faraday [#40](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/40)

# v 0.4.0
- Make the gem strictly typed using Sorbet [#34](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/34), [#35](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/35), [#37](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/37)
- Object IDs are Strings in development [#37](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/37)

# v 0.3.2
- Include Zeitwerk

# v 0.3.1
- Update Meta API to v14

# v 0.3.0
- Allow Apps to have a singleton global authentication client.

# v 0.2.0
- Added Media API
- Added error and successful responses
- Added faraday-multipart as part of the library
 
# v 0.1.0
- Added Message Template API.
- Added Currency and DateTime resources.
- Added Media resource.
- Added Component and ParameterObject resource.
- Fixed bug in recipient_number in Messages API.

# v 0.0.2
- Implement read message.
- Implement Yard doc.
