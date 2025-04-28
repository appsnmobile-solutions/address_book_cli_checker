# frozen_string_literal: true

class CustomFormatter
  RSpec::Core::Formatters.register self, :start, :example_passed, :example_failed, :example_pending, :finish

  def initialize(output)
    @output = output
  end

  def start(_notification)
    @output.puts "Validating your Address Book application...🔍"
    @output.puts "\nAddressBook UI Flow"
  end

  def example_passed(notification)
    @output.puts "  #{notification.example.description} (PASSED)"
  end

  def example_failed(notification)
    @output.puts "  #{notification.example.description} (FAILED)"
    @output.puts "    #{notification.exception.message}"
    # You can customize the stack trace or other output here as well
  end

  def example_pending(notification)
    @output.puts "  #{notification.example.description} (PENDING)"
  end

  def finish(_notification)
    @output.puts "\nFinished in #{RSpec.world.example_count} examples."
    @output.puts "#{RSpec.world.failed_count} failures."
    # You can add more details here, like showing failure summaries or other stats
  end
end
