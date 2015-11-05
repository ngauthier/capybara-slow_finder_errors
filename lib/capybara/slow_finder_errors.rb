require 'capybara'
module Capybara
  class SlowFinderError < CapybaraError; end

  module Node
    class Base
      def synchronize_with_timeout_error(*args, &block)
        start_time = Time.now
        synchronize_without_timeout_error(*args, &block)
      rescue Capybara::ElementNotFound => e
        seconds = args.first || Capybara.default_max_wait_time
        if seconds > 0 && Time.now-start_time > seconds
          raise SlowFinderError, "Timeout reached while running a *waiting* Capybara finder...perhaps you wanted to return immediately? Use a non-waiting Capybara finder. More info: http://blog.codeship.com/faster-rails-tests?utm_source=gem_exception"
        end
        raise
      end
      alias_method :synchronize_without_timeout_error, :synchronize
      alias_method :synchronize, :synchronize_with_timeout_error
    end
  end
end
