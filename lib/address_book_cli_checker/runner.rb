# frozen_string_literal: true

require "rspec"

module AddressBookCliChecker
  class Runner
    def self.run(path_to_main)
      $LOAD_PATH.unshift(File.expand_path(File.dirname(path_to_main)))
      require_relative path_to_main

      RSpec::Core::Runner.run([File.expand_path("../../spec/ui_flow_spec.rb", __dir__)])
    end
  end
end
