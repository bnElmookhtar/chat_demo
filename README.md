# GOATMessenger 📱

A simple **cross-platform messaging app** developed as part of the **Database Systems Course Project (May 2023)**.  
GOATMessenger enables users to communicate seamlessly through personal chats, groups, and broadcasts.

---

## 🚀 Features
- **User Authentication** – Secure registration and login via unique phone numbers.  
- **Personal Chats** – One-to-one private messaging.  
- **Group Chats** – Multi-user conversations with admin privileges.  
- **Broadcasts** – Send a single message to multiple users simultaneously.  
- **Message Management** – Send, receive, and delete messages.  
- **Settings** – Manage account details, chats, and group/broadcast preferences.  

---

## 🛠️ Tech Stack
- **Frontend & Mobile App:** Flutter (Dart)  
- **Backend:** PHP (REST API)  
- **Database:** MySQL  
- **Server:** Apache on Linux  

---

## 🗄️ Database Design
- **Entity Relationship Diagram (ERD):**  
  ![ERD](docs/erdDiagram.png)  

---

## 📸 Screenshots

### 🔑 Login & Registration
<p align="center">
  <img src="docs/screenshots/login.jpg" alt="Login" width="250"/>
  <img src="docs/screenshots/register.jpg" alt="Register" width="250"/>
</p>

### 🏠 Home Page (Chats Overview)
<p align="center">
  <img src="docs/screenshots/broadcasts.jpg" alt="Broadcasts" width="220"/>
  <img src="docs/screenshots/persons.jpg" alt="Persons" width="220"/>
  <img src="docs/screenshots/groups.jpg" alt="Groups" width="220"/>
</p>

### 💬 Chat Pages
<p align="center">
  <img src="docs/screenshots/broadcast.jpg" alt="Broadcast Chat" width="220"/>
  <img src="docs/screenshots/sendMessage.jpg" alt="Personal Chat" width="220"/>
  <img src="docs/screenshots/group.jpg" alt="Group Chat" width="220"/>
</p>

### ➕ Create Chats
<p align="center">
  <img src="docs/screenshots/contacts.jpg" alt="Contacts" width="220"/>
  <img src="docs/screenshots/createBroadcast.jpg" alt="Create Broadcast" width="220"/>
  <img src="docs/screenshots/createGroup.jpg" alt="Create Group" width="220"/>
</p>

### ⚙️ Settings & Management
<p align="center">
  <img src="docs/screenshots/account.jpg" alt="Account Settings" width="200"/>
  <img src="docs/screenshots/broadcastSettings.jpg" alt="Broadcast Settings" width="200"/>
  <img src="docs/screenshots/personSettings.jpg" alt="Personal Chat Settings" width="200"/>
</p>

<p align="center">
  <img src="docs/screenshots/groupSettingsAdmin.jpg" alt="Group Settings (Admin)" width="200"/>
  <img src="docs/screenshots/groupSettingsMember.jpg" alt="Group Settings (Member)" width="200"/>
  <img src="docs/screenshots/blocked.jpg" alt="Blocked Users" width="200"/>
</p>



---

## 📂 Project Structure

The repository is organized as follows:

```
.
├── android/                  # Android-specific project files and build configs
├── docs/                     # Documentation assets (ERD, screenshots, etc.)
├── lib/                      # Flutter application source code
│   ├── data/                 # Data handling (API requests, sessions, etc.)
│   ├── pages/                # UI screens and app pages
│   ├── tools/                # Utility functions (formatting, helpers)
│   ├── widgets/              # Reusable UI components (dialogs, snackbars)
│   └── main.dart             # App entry point
├── linux/                    # Linux-specific project files
├── php/                      # Backend PHP API endpoint(s)
├── pubspec.yaml              # Flutter dependencies and configuration
├── analysis_options.yaml      # Linting and code style rules
└── README.md                 # Project documentation
```

### ▶️ How to Run
1. **Install dependencies**  
   ```bash
   flutter pub get
   ```
2. **Run the app (mobile or desktop)**  
   ```bash
   flutter run
   ```
3. **Backend setup**  
   - Deploy `php/index.php` to an Apache server with MySQL configured.  
   - Update API endpoint URLs in the Flutter app if needed.  
