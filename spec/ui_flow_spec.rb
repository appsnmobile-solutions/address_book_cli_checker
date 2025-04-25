# frozen_string_literal: true

RSpec.describe "AddressBook UI Flow" do
  def simulate_input(inputs)
    input_io = StringIO.new("#{inputs.join("\n")}\n")
    output_io = StringIO.new

    $stdin = input_io
    $stdout = output_io

    begin
      raise "Expected a 'main' method to be defined in the given file." unless defined?(main)

      main
    rescue SystemExit
      # Allow exit to pass silently
    end

    output_io.rewind
    output_io.read
  ensure
    $stdin = STDIN
    $stdout = STDOUT
  end

  it "shows main menu on start" do
    output = simulate_input(["5"])
    expect(output).to include("Welcome to the Address Book!")
    expect(output).to include("1. Add Contact")
    expect(output).to include("2. View Contacts")
    expect(output).to include("3. Edit Contact")
    expect(output).to include("4. Delete Contact")
    expect(output).to include("5. Exit")
  end

  it "allows user to add a contact and confirms" do
    output = simulate_input(%w[1 Kofi Doe 0586748390 1 2 5])
    expect(output).to include("--- Add a New Contact ---")
    expect(output).to include("Enter First Name:")
    expect(output).to include("Enter Last Name:")
    expect(output).to include("Enter Phone Number:")
    expect(output).to include("--- Summary ---")
    expect(output).to include("First Name: Kofi")
    expect(output).to include("Last Name: Doe")
    expect(output).to include("Phone Number: 0586748390")
    expect(output).to include("Contact added successfully!")
    expect(output).to include("Kofi Doe - 0586748390")
  end

  it "allows user to edit details while adding a contact before saving" do
    output = simulate_input(["1", "Kwame", "Boateng", "0244000000", "2", "Kwame Jr.", "", "", "1", "2", "5"])

    expect(output).to include("--- Add a New Contact ---")
    expect(output).to include("Enter First Name:")
    expect(output).to include("Enter Last Name:")
    expect(output).to include("Enter Phone Number:")

    expect(output).to include("--- Summary ---")
    expect(output).to include("First Name: Kwame")
    expect(output).to include("Last Name: Boateng")
    expect(output).to include("Phone Number: 0244000000")

    expect(output).to include('Enter new First Name (press Enter to keep "Kwame"):')
    expect(output).to include('Enter new Last Name (press Enter to keep "Boateng"):')
    expect(output).to include('Enter new Phone Number (press Enter to keep "0244000000"):')

    expect(output).to include("--- Summary ---")
    expect(output).to include("First Name: Kwame Jr.")
    expect(output).to include("Last Name: Boateng")
    expect(output).to include("Phone Number: 0244000000")
    expect(output).to include("Contact added successfully!")
    expect(output).to include("1. Kwame Jr. Boateng - 0244000000")
  end

  it "shows view contacts with no contacts" do
    output = simulate_input(%w[2 5])
    expect(output).to include("No contacts found.")
  end

  it "shows list of contacts when contacts exist" do
    output = simulate_input(%w[1 Kofi Doe 0586748390 1 2 5])
    expect(output).to include("--- Your Contacts ---")
    expect(output).to include("1. Kofi Doe - 0586748390")
  end

  it "allows user to keep existing details unchanged when editing a contact" do
    output = simulate_input([
                              "1", "Akua", "Mensah", "0555000000", "1",
                              "3", "1", "", "", "", "1",
                              "2", "5"
                            ])
    expect(output).to include('Enter new First Name (press Enter to keep "Akua"):')
    expect(output).to include('Enter new Last Name (press Enter to keep "Mensah"):')
    expect(output).to include('Enter new Phone Number (press Enter to keep "0555000000"):')
    expect(output).to include("Contact updated successfully!")
    expect(output).to include("1. Akua Mensah - 0555000000")
  end

  it "edits an existing contact and saves the changes" do
    output = simulate_input([
                              "1", "Ama", "Mensah", "0201234567", "1",
                              "3", "1", "Ama-Gold", "", "0200000000", "1",
                              "2", "5"
                            ])

    expect(output).to include("--- Edit a Contact ---")
    expect(output).to include('Enter new First Name (press Enter to keep "Ama"):')
    expect(output).to include('Enter new Last Name (press Enter to keep "Mensah"):')
    expect(output).to include('Enter new Phone Number (press Enter to keep "0201234567"):')
    expect(output).to include("--- Summary ---")
    expect(output).to include("First Name: Ama-Gold")
    expect(output).to include("Last Name: Mensah")
    expect(output).to include("Phone Number: 0200000000")
    expect(output).to include("Contact updated successfully!")
    expect(output).to include("1. Ama-Gold Mensah - 0200000000")
  end

  it "deletes a contact after confirmation" do
    output = simulate_input(%w[
                              1 John Doe 0551111222 1
                              4 1 y
                              2 5
                            ])

    expect(output).to include("--- Delete a Contact ---")
    expect(output).to include("Select the number of the contact: ")
    expect(output).to include('Are you sure you want to delete "John Doe"? (y/n):')
    expect(output).to include("🗑 Contact deleted.")
    # expect(output).not_to include("John Doe - 0551111222")
  end

  it "handles invalid menu option gracefully" do
    output = simulate_input(%w[7 hello 5])
    expect(output).to include("Invalid option. Please try again.")
    expect(output.scan("Please choose an option:").size).to be > 1
  end

  it "handles invalid contact selection when editing" do
    output = simulate_input([
                              "1", "John", "Smith", "0200000000", "1",
                              "3", "5", "1", "", "", "", "1", "5"
                            ])
    expect(output).to include("Invalid selection. Try again.")
  end

  it "allows the user to cancel adding a contact and return to the main menu" do
    output = simulate_input(%w[1 Kofi Doe 0586748390 3 5])
    expect(output).to include("--- Add a New Contact ---")
    expect(output).to include("Cancel and Return to Main Menu")
    expect(output).to include("Please choose an option:")
  end

  it "allows the user to cancel editing a contact and return to the main menu" do
    output = simulate_input([
                              "1", "Ama", "Mensah", "0201234567", "1",
                              "3", "1", "", "", "", "3", "5"
                            ])
    expect(output).to include("Cancel and Return to Main Menu")
    expect(output.scan("Please choose an option:").size).to be > 1
  end

  it "does not allow adding a contact with empty fields" do
    output = simulate_input(["1", "", "Kofi", "", "Ama", "", "0559968790", "1", "2", "5"])

    expect(output).to include("First name cannot be empty.")
    expect(output).to include("Last name cannot be empty.")
    expect(output).to include("Phone number cannot be empty.")
  end

  it "shows error on invalid index when deleting and returns to main menu after 5 attempts" do
    output = simulate_input(%w[
                              1 Yaw Asante 0501234567 1
                              4 5 5 5 5 5 5
                            ])
    expect(output).to include("Invalid selection. Try again.")
  end

  it "adds 100 contacts without crashing" do
    lines = []
    100.times do |i|
      lines += ["1", "First#{i}", "Last#{i}", "050#{i.to_s.rjust(7, "0")}", "1"]
    end
    lines += %w[2 5]
    output = simulate_input(lines)

    expect(output).to include("100. First99 Last99 - 0500000099")
  end
end
