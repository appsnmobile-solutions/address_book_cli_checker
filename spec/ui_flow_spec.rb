# frozen_string_literal: true

require_relative "./spec_helper"
require "stringio"

RSpec.describe "AddressBook UI Flow" do
  def simulate_input(inputs)
    input_io = StringIO.new("#{inputs.join("\n")}\n")
    output_io = StringIO.new

    setup_io(input_io, output_io)
    run_main
    output_io.rewind
    output_io.read
  ensure
    teardown_io
  end

  def setup_io(input_io, output_io)
    $stdin = input_io
    $stdout = output_io
  end

  def run_main
    raise "Expected a 'main' method to be defined in the given file." unless defined?(main)

    main
  rescue SystemExit
    # Allow exit to pass silently
  end

  def teardown_io
    $stdin = STDIN
    $stdout = STDOUT
  end

  def expected_output(output)
    "Expected output to include '#{output}'"
  end

  def check_main_menu(output)
    expect(output).to include("Welcome to the Address Book!"), expected_output("Welcome to the Address Book!")
    expect(output).to include("1. Add Contact"), expected_output("1. Add Contact")
    expect(output).to include("2. View Contacts"), expected_output("2. View Contacts")
    expect(output).to include("3. Edit Contact"), expected_output("3. Edit Contact")
    expect(output).to include("4. Delete Contact"), expected_output("4. Delete Contact")
    expect(output).to include("5. Exit"), expected_output("5. Exit")
  end

  def check_contact_summary(output, first_name, last_name, phone_number)
    expect(output).to include("--- Summary ---"), expected_output("--- Summary ---")
    expect(output).to include("First Name: #{first_name}"), expected_output("First Name: [first_name]")
    expect(output).to include("Last Name: #{last_name}"), expected_output("Last Name: [last_name]")
    expect(output).to include("Phone Number: #{phone_number}"), expected_output("Phone Number: [phone_number]")
  end

  def check_add_contact_view(output, first_name, last_name, phone_number)
    expect(output).to include("--- Add a New Contact ---"), expected_output("--- Add a New Contact ---")
    expect(output).to include("Enter First Name:"), expected_output("Enter First Name:")
    expect(output).to include("Enter Last Name:"), expected_output("Enter Last Name:")
    expect(output).to include("Enter Phone Number:"), expected_output("Enter Phone Number:")
    check_contact_summary(output, first_name, last_name, phone_number)
  end

  def check_view_contacts_view(output, contacts)
    if contacts.empty?
      expect(output).to include("No contacts found."), expected_output("No contacts found.")
    else
      expect(output).to include("--- View Contacts ---"), expected_output("--- View Contacts ---")
      contacts.each do |contact|
        expect(output).to include("#{contact[0]} #{contact[1]} - #{contact[2]}"),
                          expected_output("#{contact[0]} #{contact[1]} - #{contact[2]}")
      end
    end
  end

  def check_success_message(output, action)
    expect(output).to include("Contact #{action} successfully!"),
                      expected_output("Contact #{action} successfully!")
  end

  def check_exit_message(output)
    expect(output).to include("Goodbye!"), expected_output("Goodbye!")
  end

  def check_edit_details_view(output, first_name, last_name, phone_number)
    expect(output).to include("Enter new First Name (press Enter to keep \"#{first_name}\"):"),
                      expected_output("Enter new First Name (press Enter to keep \"[first name]\"):")
    expect(output).to include("Enter new Last Name (press Enter to keep \"#{last_name}\"):"),
                      expected_output("Enter new Last Name (press Enter to keep \"[last name]\"):")
    expect(output).to include("Enter new Phone Number (press Enter to keep \"#{phone_number}\"):"),
                      expected_output("Enter new Phone Number (press Enter to keep \"[phone number]\"):")
  end

  def check_edit_contact_view(output, prev_contact, curr_contact)
    expect(output).to include("--- Edit a Contact ---"), expected_output("--- Edit a Contact ---")
    check_edit_details_view(output, prev_contact[0], prev_contact[1], prev_contact[2])
    check_contact_summary(output, curr_contact[0], curr_contact[1], curr_contact[2])
  end

  def check_delete_contact_view(output, first_name, last_name, confirmation = true)
    expect(output).to include("--- Delete a Contact ---"), expected_output("--- Delete a Contact ---")
    expect(output).to include("Select the number of the contact: "),
                      expected_output("Select the number of the contact: ")
    if confirmation
      expect(output).to include("Are you sure you want to delete \"#{first_name} #{last_name}\"? (y/n):"),
                      expected_output("Are you sure you want to delete \"[first name] [last name]\"? (y/n):")
    end
  end



  def check_invalid_option_message(output)
    expect(output).to include("Invalid option. Please try again."), expected_output("Invalid option. Please try again.")
    expect(output.scan("Please choose an option:").size).to be > 1,
                                                            expected_output("Please choose an option: more than once")
  end

  def check_invalid_field_message(output)
    expect(output).to include("Invalid field. Please try again."), expected_output("Invalid field. Please try again.")
  end

  def check_invalid_index_message(output)
    expect(output).to include("Invalid selection. Try again."), expected_output("Invalid selection. Try again.")
  end

  it "shows main menu on start" do
    output = simulate_input(["5"])
    check_main_menu(output)
    check_exit_message(output)
  end

  it "allows user to add a contact and confirms" do
    output = simulate_input(%w[1 Kofi Doe 0586748390 1 2 5])
    check_main_menu(output)
    check_add_contact_view(output, "Kofi", "Doe", "0586748390")
    check_success_message(output, "added")
    check_main_menu(output)
    check_view_contacts_view(output, [%w[Kofi Doe 0586748390]])
    check_main_menu(output)
    check_exit_message(output)
  end

  it "allows user to edit details while adding a contact before saving" do
    output = simulate_input(["1", "Kwame", "Boateng", "0244000000", "2", "Kwame Jr.", "", "", "1", "2", "5"])
    check_main_menu(output)
    check_add_contact_view(output, "Kwame", "Boateng", "0244000000")
    check_edit_details_view(output, "Kwame", "Boateng", "0244000000")
    check_success_message(output, "added")
    check_main_menu(output)
    check_view_contacts_view(output, [["Kwame Jr.", "Boateng", "0244000000"]])
    check_main_menu(output)
    check_exit_message(output)
  end

  it "shows view contacts with no contacts" do
    output = simulate_input(%w[2 5])
    check_main_menu(output)
    check_view_contacts_view(output, [])
    check_main_menu(output)
    check_exit_message(output)
  end

  it "shows list of contacts when contacts exist" do
    output = simulate_input(%w[1 Kofi Doe 0586748390 1 2 5])
    check_main_menu(output)
    check_add_contact_view(output, "Kofi", "Doe", "0586748390")
    check_success_message(output, "added")
    check_main_menu(output)
    check_view_contacts_view(output, [%w[Kofi Doe 0586748390]])
    check_main_menu(output)
    check_exit_message(output)
  end

  it "allows user to keep existing details unchanged when editing a contact" do
    output = simulate_input([
                              "1", "Akua", "Mensah", "0555000000", "1",
                              "3", "1", "", "", "", "1",
                              "2", "5"
                            ])
    check_main_menu(output)
    check_add_contact_view(output, "Akua", "Mensah", "0555000000")
    check_success_message(output, "added")
    check_main_menu(output)
    check_edit_contact_view(output, %w[Akua Mensah 0555000000], %w[Akua Mensah 0555000000])
    check_success_message(output, "updated")
    check_main_menu(output)
    check_view_contacts_view(output, [%w[Akua Mensah 0555000000]])
    check_main_menu(output)
    check_exit_message(output)
  end

  it "edits an existing contact and saves the changes" do
    output = simulate_input([
                              "1", "Ama", "Mensah", "0201234567", "1",
                              "3", "1", "Ama-Gold", "", "0200000000", "1",
                              "2", "5"
                            ])

    check_main_menu(output)
    check_add_contact_view(output, "Ama", "Mensah", "0201234567")
    check_success_message(output, "added")
    check_main_menu(output)
    check_edit_contact_view(output, %w[Ama Mensah 0201234567], %w[Ama-Gold Mensah 0200000000])
    check_success_message(output, "updated")
    check_main_menu(output)
    check_view_contacts_view(output, [%w[Ama-Gold Mensah 0200000000]])
    check_main_menu(output)
    check_exit_message(output)
  end

  it "deletes a contact after confirmation" do
    output = simulate_input(%w[
                              1 John Doe 0551111222 1
                              4 1 y
                              2 5
                            ])

    check_main_menu(output)
    check_add_contact_view(output, "John", "Doe", "0551111222")
    check_success_message(output, "added")
    check_main_menu(output)
    check_delete_contact_view(output, "John", "Doe")
    check_success_message(output, "deleted")
    check_main_menu(output)
    check_view_contacts_view(output, [])
    check_main_menu(output)
    check_exit_message(output)
    # expect(output).not_to include("John Doe - 0551111222")
  end

  it "handles invalid menu option gracefully" do
    output = simulate_input(%w[7 hello 5])
    check_main_menu(output)
    check_invalid_option_message(output)
    check_main_menu(output)
    check_exit_message(output)
  end

  it "handles invalid contact selection when editing" do
    output = simulate_input([
                              "1", "John", "Smith", "0200000000", "1",
                              "3", "5", "1", "", "", "", "1", "5"
                            ])
    check_main_menu(output)
    check_invalid_index_message(output)
  end

  it "allows the user to cancel adding a contact and return to the main menu" do
    output = simulate_input(%w[1 Kofi Doe 0586748390 3 5])
    check_main_menu(output)
    check_add_contact_view(output, "Kofi", "Doe", "0586748390")
    expect(output).not_to include("Contact added successfully!"), expected_output("Contact added successfully! should not be present")
    check_main_menu(output)
    check_exit_message(output)

  end

  it "allows the user to cancel editing a contact and return to the main menu" do
    output = simulate_input([
                              "1", "Ama", "Mensah", "0201234567", "1",
                              "3", "1", "", "", "", "3", "5"
                            ])
    check_main_menu(output)
    check_add_contact_view(output, "Ama", "Mensah", "0201234567")
    check_success_message(output, "added")
    check_main_menu(output)
    check_edit_contact_view(output, %w[Ama Mensah 0201234567], %w[Ama Mensah 0201234567])
    expect(output).not_to include("Contact updated successfully!"), expected_output("Contact updated successfully! should not be present")
    check_main_menu(output)
    check_exit_message(output)
  end

  it "does not allow adding a contact with empty fields" do
    output = simulate_input(["1", "", "Kofi", "", "Ama", "", "0559968790", "1", "2", "5"])
    check_main_menu(output)
    # check_invalid_field_message(output)
    check_add_contact_view(output, "Kofi", "Ama", "0559968790")
    check_success_message(output, "added")
    check_main_menu(output)
    check_view_contacts_view(output, [%w[Kofi Ama 0559968790]])
    check_main_menu(output)
    check_exit_message(output)

  end

  it "shows error on invalid index when deleting and returns to main menu after 5 attempts" do
    output = simulate_input(%w[
                              1 Yaw Asante 0501234567 1
                              4 5 5 5 5 5 5
                            ])
    check_main_menu(output)
    check_add_contact_view(output, "Yaw", "Asante", "0501234567")
    check_success_message(output, "added")
    check_main_menu(output)
    check_delete_contact_view(output, "Yaw", "Asante", confirmation = false)
    check_invalid_index_message(output)
    check_main_menu(output)
    check_exit_message(output)
  end

  it "adds 100 contacts without crashing" do
    lines = []
    100.times do |i|
      lines += ["1", "First#{i}", "Last#{i}", "050#{i.to_s.rjust(7, "0")}", "1"]
    end
    lines += %w[2 5]
    output = simulate_input(lines)

    check_main_menu(output)
    expect(output).to include("100. First99 Last99 - 0500000099"), expected_output("100. First99 Last99 - 0500000099")
  end
end
