# frozen_string_literal: true

require "rspec"

module AddressBookCliChecker
  # Class responsible for running RSpec tests against the Address Book app.
  # It requires the main file of the Address Book app and executes the tests.
  # Provides a simple way to verify the app's functionality and report any issues.
  class Runner
    def self.run(path_to_main)
      require_relative path_to_main

      result = RSpec::Core::Runner.run([File.expand_path("../../spec/ui_flow_spec.rb", __dir__)])
      if result.zero?
        puts "\nAll checks passed! Your Address Book app looks great! 🎉\n\n"
      else
        puts "\nSome issues were found. Please read the suggestions above to fix them.\n\n"
      end
    rescue StandardError => e
      puts "Unexpected error: #{e.message}"
    end
  end
end
