# frozen_string_literal: true

require 'capybara'

module Capybara
  ADDITIONAL_MESSAGE = 'Timeout reached while running a *waiting* Capybara finder...perhaps you wanted to return immediately? Use a non-waiting Capybara finder. More info: http://blog.codeship.com/faster-rails-tests?utm_source=gem_exception'

  module Node
    class Base
      def synchronize_with_timeout_error(*args, **kwargs, &block)
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        synchronize_without_timeout_error(*args, **kwargs, &block)
      rescue Capybara::ElementNotFound, Capybara::ExpectationNotMet => e
        seconds = args.first || Capybara.default_max_wait_time
        raise e unless seconds > 0 && Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time > seconds

        raise e, "#{$!}\n\n#{ADDITIONAL_MESSAGE}", e.backtrace
      end

      alias_method :synchronize_without_timeout_error, :synchronize
      alias_method :synchronize, :synchronize_with_timeout_error
    end
  end
end
