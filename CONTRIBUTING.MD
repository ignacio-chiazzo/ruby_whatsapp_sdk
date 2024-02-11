Bug reports and pull requests are welcome on GitHub at [https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk) This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

If you want a feature implemented in the gem, please open an issue, and we will look as soon as we can. 

Do you want to contribute and are unsure where to start? Ping me on Twitter, and I will help you!

### Getting started

Clone the project and ensure tests are passing locally.

```console
bundle install
bundle exec rake test
```

#### Configure an App and enable WhatsApp

Follow the steps in the [Readme#set-up-a-meta-app](/README.md#set-up-a-meta-app)

#### Architecture

The main logic lives under `/lib`. There, you can find API classes (Medias, Messages, PhoneNumbers, etc.) and Resources (Button, Address, etc.). 
Each API class inherits from `Request`, which contains the helper methods to make HTTP requests to Meta. 

If you are new to the code, a good place to start is looking at [closed PRs](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pulls?q=is%3Apr+is%3Aclosed). Here are some helpful PRs: 
- [Added a new Templates API](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/90)
- [Added an error when the user entered a bad input](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/89/files)
- [Change on Faraday configuration](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/123/files).

 Do you want to contribute and are unsure where to start? Ping me on Twitter, and I will help you!