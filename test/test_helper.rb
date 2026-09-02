# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # CurrentAttributes is reset by the executor only for request-cycle tests; model
    # tests don't run through it, so clear it here to stop Current.user leaking
    # between tests (RecordEvent falls back to Current.user).
    teardown { Current.reset }

    # Add more helper methods to be used by all tests here...
  end
end
