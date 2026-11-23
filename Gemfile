# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group(:test) do
  gem('mocha')
  gem('rubocop', require: false)
  gem('rubocop-minitest', require: false)
  gem('rubocop-performance', require: false)
  gem('vcr')
  gem('webmock')
end

group(:development) do
  gem('ostruct') # pry 0.14 needs it; no longer a default gem in Ruby 4
  gem('pry')
  gem('pry-nav')
end

gemspec
