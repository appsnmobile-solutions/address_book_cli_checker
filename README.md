# AddressBookCliChecker

**AddressBookCliChecker** is a CLI tool for validating the user interface (UI) flow of Ruby-based command-line address book applications. It runs automated RSpec tests against your app to ensure the user experience follows a predictable, guided pattern.

---

## ✨ Features
- Validates user interface flows of address book CLI apps
- Detects UI mismatches automatically
- Runs with a simple terminal command

---

## 📦 Installation

Add this line to your application's Gemfile:

```ruby
gem 'address_book_cli_checker', git: 'https://github.com/appsnmobile-solutions/address_book_cli_checker'
```

Then execute:

```bash
bundle install
```

Or install it directly with:

```bash
gem install 'address_book_cli_checker', git: 'https://github.com/appsnmobile-solutions/address_book_cli_checker'
```

---

## 🚀 Usage

To use the checker on your Ruby CLI address book app:

```bash
address_book_cli_checker path/to/your_script.rb
```

The gem will execute your app and validate whether the UI screens match the expectations defined in the **UI Flow Guide** below.

---

📒 UI Flow Guide

This guide defines how your CLI should behave in various scenarios. Your app must match this structure for validation to pass.
See the full [Address Book UI Flow Guide](UI_GUIDE.md).

---

## 🔧 Development

After cloning:
```bash
git clone https://github.com/appsnmobile-solutions/address_book_cli_checker.git
cd address_book_cli_checker
bundle install
```

Run tests:
```bash
rake spec
```

Interactive console:
```bash
bin/console
```

Install locally:
```bash
bundle exec rake install
```

Release new version:
1. Update `version.rb`
2. Run:
```bash
bundle exec rake release
```

---

## 🤝 Contributing

Bug reports and pull requests are welcome on GitHub at:
[https://github.com/appsnmobile-solutions/address_book_cli_checker](https://github.com/appsnmobile-solutions/address_book_cli_checker)

---

## 🧾 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

---

## 🧭 Code of Conduct

Everyone interacting in this project’s codebases, issue trackers, and community spaces is expected to follow the [Code of Conduct](https://github.com/appsnmobile-solutions/address_book_cli_checker/blob/main/CODE_OF_CONDUCT.md).

