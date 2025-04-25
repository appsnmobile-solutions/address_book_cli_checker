# frozen_string_literal: true

require_relative "lib/address_book_cli_checker/version"

Gem::Specification.new do |spec|
  spec.name = "address_book_cli_checker"
  spec.version = AddressBookCliChecker::VERSION
  spec.authors = ["yesuko"]
  spec.email = ["assankumdev@gmail.com"]

  spec.summary       = "CLI tool to validate UI flows for address book CLI apps"
  spec.description   = "Runs RSpec tests on command-line Ruby apps to ensure their UI follows a predefined sequence."
  spec.homepage      = "https://github.com/appsnmobile-solutions"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/appsnmobile-solutions/address_book_cli_checker"
  spec.metadata["changelog_uri"] = "https://github.com/appsnmobile-solutions/address_book_cli_checker/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  # spec.bindir = "exe"
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.executables = ["address_book_cli_checker"]
  spec.require_paths = ["lib"]
  spec.add_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.21"


  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
