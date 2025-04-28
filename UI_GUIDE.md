# 📒 Address Book – UI Flow Guide

This document describes all the user interface views for the command-line **Address Book** application. It guides developers on what each user screen should display and expect, to ensure the full experience is implemented consistently.

---

## 🏁 1. Application Start View

### **Main Menu**
```
Welcome to the Address Book!
-----------------------------
Please choose an option:
1. Add Contact
2. View Contacts
3. Edit Contact
4. Delete Contact
5. Exit
```

---

## 📁 2. Add Contact View

### **Prompt for Contact Details**
```
--- Add a New Contact ---
Enter First Name:
Enter Last Name:
Enter Phone Number:
```
If invalid:
```
Invalid input. Try again.
```
Returns to main after 5 retries.

### **Summary Confirmation**
If all inputs are valid:
```
--- Summary ---
First Name: Kofi
Last Name: Doe
Phone Number: 0586748390

What would you like to do next?
1. Save Contact
2. Edit Details
3. Cancel and Return to Main Menu
```

#### **1. Save Contact**
```
Contact added successfully!
```
Returns to main menu.

#### **2. Edit Details**
```
Enter new First Name (press Enter to keep "Kofi"):
Enter new Last Name (press Enter to keep "Doe"):
Enter new Phone Number (press Enter to keep "0586748390"):
```
Then show the summary confirmation again.

---

## 📄 3. View Contacts View

### **When Contacts Exist**
```
--- Your Contacts ---
1. Kofi Doe - 0586748390
2. Ama Mensah - 0201234567
...
```

### **When No Contacts Exist**
```
No contacts found.
```

Returns to main menu.

---

## ✏️ 4. Edit Contact View

### **Prompt to Select a Contact**
```
--- Edit a Contact ---
Select the number of the contact to edit:
1. Kofi Doe - 0586748390
2. Ama Mensah - 0201234567
```
If invalid:
```
Invalid selection. Try again.
```
Returns to main after 5 retries.

### **Prompt for Edit Details**
Same as Add Contact View's Edit Details.

### **Summary Confirmation**
Same as Add Contact View's Summary Confirmation.

#### **1. Save Contact**
```
Contact updated successfully!
```
Returns to main menu.

---

## 🗑 5. Delete Contact View

### **Prompt to Select a Contact**
```
--- Delete a Contact ---
Select the number of the contact to delete:
1. Kofi Doe - 0586748390
2. Ama Mensah - 0201234567
```
If invalid:
```
Invalid selection. Try again.
```
Returns to main after 5 retries.

### **Confirmation Prompt (Optional)**
```
Are you sure you want to delete "Kofi Doe"? (y/n):
```

### **Success Message**
If choice is 'y':
```
🗑 Contact deleted.
```

### **Delete Cancellation Message**
If choice is 'n':
```
Contact Deletion Canceled.
```
Returns to main menu.

---

## ❌ 6. Exit View

When user selects Exit:
```
Goodbye! 👋
```

Application terminates.

---

## 🚫 7. Invalid Option Handling (Main Menu)

If user enters anything other than 1–5:
```
Invalid option. Please try again.
```

Returns to main.

---

## 📌 Notes for Developers

- The application entry should be defined in a `main function`.
- Every view must **clearly guide the user** with prompts and instructions.
- After each action (add/edit/delete/view), return to the **main menu**.
- Inputs must always prompt with descriptive text (e.g. `"Enter Last Name:"`).
- Handle edge cases like empty input or invalid index **gracefully**.
- Use spacing or clearing (if available) to keep screens readable.
- Emojis or ASCII visuals help highlight success, errors, and important steps.
- Retry logic: After 5 failed attempts for input (e.g., name, phone, or selection), return the user to the main menu with a warning message.
- Reuse summary and edit prompts between add/edit views to avoid repetition.

---
