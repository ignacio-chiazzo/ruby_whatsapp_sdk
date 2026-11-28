# AGENTS.md

Guide for coding agents working on `whatsapp_sdk`, a Ruby gem for Meta's [WhatsApp Cloud API](https://developers.facebook.com/docs/whatsapp/cloud-api) (Graph API). For how to contribute, see [CONTRIBUTING.MD](CONTRIBUTING.MD). For the public API and usage examples, see [README.md](README.md).

## Commands

```bash
bundle install
bundle exec rake test                                              # full suite (default rake task)
bundle exec rake test TEST=test/whatsapp/api/templates_test.rb     # one file
bundle exec ruby -Itest test/whatsapp/api/templates_test.rb -n /invalid/  # filter by test name
bundle exec rubocop                                                # lint; CI runs it with the tests
```

## Architecture

The code is hand-written (no code generation), with Faraday for HTTP and Zeitwerk for autoloading (`lib/whatsapp_sdk.rb`).

- `lib/whatsapp_sdk/api/client.rb`: `Api::Client` holds the token and API version, caches Faraday connections per origin, and exposes the API objects (`client.messages`, `client.media`, `client.templates`, `client.phone_numbers`, `client.business_profiles`, `client.business_accounts`, `client.flows`). `send_request` parses JSON and raises `Api::Responses::HttpResponseError` for any status >= 400 or a Graph `error` body, unless the caller passes `raw_response: true`.
- `lib/whatsapp_sdk/api/*.rb`: one class per API area, each inheriting from `Api::Request`, which forwards to the client. Public methods take keyword arguments, call `send_request(endpoint:, http_method:, params:, headers:)`, and return a resource or response object.
- `lib/whatsapp_sdk/api/responses/`: response wrappers (`MessageDataResponse`, `SuccessResponse`, `IdResponse`, `PaginationRecords`, `HttpResponseError`, `GenericErrorResponse`, `RawResponse`).
- `lib/whatsapp_sdk/resource/`: value objects and enums (`Template`, `Message`, `Interactive*`, `Languages`, ...). Objects built from API data use `self.from_hash`; objects sent to the API implement `to_json` (or `to_h`).
- `lib/whatsapp_sdk/configuration.rb`: the global `WhatsappSdk.configure` singleton. `Client.new` defaults to its values.
- `example.rb`: a manual script that calls the real API with a real token. It is not run in CI and rubocop excludes it.

## Common changes

**New endpoint or option**
1. Add a method to the matching `lib/whatsapp_sdk/api/*.rb` class, following its neighbours. Add a `Resource` class if the response deserves one.
2. Document the public method with YARD (`@param`, `@return`, `@raise`).
3. Add tests (see Testing) for the success and error responses.
4. Add a usage example to the matching README section and, where useful, to `example.rb`.
5. Add a CHANGELOG entry.

**New Graph API version**: prepend it to `API_VERSIONS` in `lib/whatsapp_sdk/api/client.rb`, add a test in `test/whatsapp/api/client_test.rb`, and add a CHANGELOG entry (see [#213](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/213)). Don't change `DEFAULT_API_VERSION` in `api_configuration.rb` as part of this: it changes behaviour for every caller that relies on the default, so it is a separate, breaking change.

**Release** (maintainer only): bump `lib/whatsapp_sdk/version.rb`, `test/whatsapp/version_test.rb`, and the gem's entry in `Gemfile.lock`, and rename `# Unreleased` in the CHANGELOG to `# v X.Y.Z`. See [#214](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/214).

## Testing

- Minitest with Mocha, WebMock and VCR. Tests live in `test/whatsapp/{api,resource}/`, mirroring `lib/`.
- `test/test_helper.rb` puts `lib/whatsapp_sdk` on the load path, so tests `require 'api/templates'`, not `whatsapp_sdk/api/templates`.
- HTTP tests replay VCR cassettes from `test/fixtures/vcr_cassettes/<area>/<test_name>.yml` via `VCR.use_cassette(...)`. Smaller cases use WebMock `stub_request` directly.
- You can't record new cassettes without a real `WHATSAPP_ACCESS_TOKEN` and a Meta app. If you don't have one, write the cassette or WebMock stub by hand from the request and response shapes in Meta's docs, and say so in the PR.
- **Never commit secrets.** Cassettes must contain `<ACCESS_TOKEN>`, not a real token. Replace real phone numbers, WABA IDs and names with fake values.
- Validation that raises before any request (invalid language, category, missing argument) is tested with `assert_raises`, without cassettes.
- Every bug fix needs a test that fails without the fix.

## Constraints

- **Backwards compatibility matters.** Don't rename or remove public methods, keywords, or return types without a deprecation path. Breaking changes need a `**Breaking:**` CHANGELOG entry and the maintainer's approval.
- **Leave validation to the API.** Send what the caller passed and let Meta return the error, instead of adding client-side checks that go stale. The existing enum checks (`Languages`, template categories, parameter formats) are established precedent, not a pattern to extend.
- **Check claims about the API** against the [official Cloud API docs](https://developers.facebook.com/docs/whatsapp/cloud-api) before writing them into code, YARD or the README. Don't guess endpoint paths, field names or limits.
- Runtime dependencies are only `faraday`, `faraday-multipart` and `zeitwerk`. Don't add more without the maintainer's approval.
- No Sorbet. Don't add `# typed:` sigils, `sig` blocks or RBI files (Sorbet was removed in v0.13.0).

## Style

- RuboCop config: `.rubocop.yml`. Lines are at most 120 characters. Single or double quotes are both accepted (`Style/StringLiterals` is off), so match the surrounding code.
- Every Ruby file starts with `# frozen_string_literal: true`.
- Use YARD on public methods. Skip comments that only restate the code.
- Keep diffs focused. Don't reformat or refactor unrelated code.

## CHANGELOG and PRs

- Add user-facing changes under `# Unreleased` at the top of `CHANGELOG.md`:
  `- Short description. @github-user [123](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/pull/123)`
- One logical change per PR, against `main`. Run `bundle exec rake test` and `bundle exec rubocop` before pushing.
- In the PR description, say what changed, how it was tested, and what was not verified against the real API.
