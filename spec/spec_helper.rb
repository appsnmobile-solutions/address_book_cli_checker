# frozen_string_literal: true

require_relative "./custom_formatter"

RSpec.configure do |config|
  config.color = true
  config.formatter = CustomFormatter

  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
