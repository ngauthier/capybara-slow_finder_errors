# Capybara::SlowFinderErrors

Raises an error when you use a capybara finder and it times out.

The goal of this gem is to aid in discovering errors in capybara usage to help speed up your test suite.

## Example

If you do:

```ruby
refute page.has_content?("An Error Occurred")
```

To make sure there's no error on the page, the full timeout will be reached because `has_content?` waits for the content to appear. The correct usage is:

```ruby
assert page.has_no_content?("An Error Occurred")
```

Which would evaluate quickly.

This gem will raise a `Capybara::SlowFinderError` whenever the first situation occurs. In fact, it raises the error any time a Capybara synchronized piece of code reaches a timeout.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara-slow_finder_errors'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-slow_finder_errors

## Usage

Run your test suite as usual. If you have any slow finders, you'll get a stack trace like this:

```
Capybara::SlowFinderError (Capybara::SlowFinderError)
/path/to/capybara-slow_finder_errors/lib/capybara/slow_finder_errors.rb:11:in `rescue in synchronize_with_timeout_error'
/path/to/capybara-slow_finder_errors/lib/capybara/slow_finder_errors.rb:7:in `synchronize_with_timeout_error'
./features/support/signed_in_user.rb:31:in `signed_in?'
./features/support/user_helper.rb:59:in `sign_in_as'
features/configuring_a_project.feature:6:in `Given I am signed in as "herbert@awesomestartup.com"'

execution expired (Timeout::Error)
/path/to/.gems/gems/poltergeist-1.5.1/lib/capybara/poltergeist/web_socket_server.rb:72:in `select'
/path/to/.gems/gems/poltergeist-1.5.1/lib/capybara/poltergeist/web_socket_server.rb:72:in `receive'
/path/to/.gems/gems/poltergeist-1.5.1/lib/capybara/poltergeist/web_socket_server.rb:85:in `send'
/path/to/.gems/gems/poltergeist-1.5.1/lib/capybara/poltergeist/server.rb:33:in `send'
/path/to/.gems/gems/poltergeist-1.5.1/lib/capybara/poltergeist/browser.rb:270:in `command'
/path/to/.gems/gems/poltergeist-1.5.1/lib/capybara/poltergeist/browser.rb:106:in `evaluate'
/path/to/.gems/gems/poltergeist-1.5.1/lib/capybara/poltergeist/driver.rb:130:in `evaluate_script'
/path/to/.gems/gems/capybara-2.4.4/lib/capybara/session.rb:527:in `evaluate_script'
...
```

If you look at the lines below the gem's trace, you'll see that the slow finder is in `signed_in_user.rb` on line 31 in the `signed_in?` method. Just follow those traces and clean up your code!

## Common Fixes

This section will hopefully grow as people contribute common situations and fixes.

### Inverted Finder

Replace `refute page.has_content?("abc")` with `assert page.has_no_content?("abc")`.

### Boolean Finder

A method that returns a boolean shouldn't use a waiting finder. So:

```ruby
def signed_in?
  page.has_content?("Sign out")
end
```

Returns true if they are signed in, but it waits a full timeout before returning false. Instead, perform a waiting finder for content that is always present (to ensure the page is loaded) then use a quick finder that doesn't wait:

```ruby
def signed_in?
  page.has_content?("Dashboard")
  page.all('a', :text => 'Home').any?
end
```

## Contributing

1. Fork it `https://github.com/ngauthier/capybara-slow_finder_errors/fork`
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
