# 📝 Notes App

<p align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Node.js](https://img.shields.io/badge/Node.js-Express-green?logo=node.js)
![MongoDB](https://img.shields.io/badge/Database-MongoDB-green?logo=mongodb)
![JWT](https://img.shields.io/badge/Auth-JWT-orange)
![Provider](https://img.shields.io/badge/State%20Management-Provider-purple)

</p>

A full-stack Notes application built using **Flutter**, **Node.js**, **Express.js**, and **MongoDB**. The application allows users to securely manage personal notes with authentication, search, tags, pinning, archiving, pagination, dark mode, and a clean mobile user experience.

---

# 📖 Project Overview

This project was developed to practice real-world full-stack mobile application development.

The application focuses on secure note management while following clean architecture principles on both the frontend and backend.

Every authenticated user has access only to their own notes, ensuring data privacy and security.

---

# ✨ Features

## 🔐 Authentication

* User Registration
* User Login
* JWT Authentication
* Password Hashing using bcrypt
* Protected Routes
* Auto Login
* Secure Logout
* Token Persistence using SharedPreferences

---

## 📝 Notes Management

* Create Notes
* Edit Notes
* Delete Notes
* Pin Notes
* Archive Notes
* View Individual Note
* User-specific Notes

---

## 🔍 Smart Search

* MongoDB Text Search
* Search by Title
* Search by Content
* Debounced Search
* Fast Search Experience

---

## 🏷 Tags

* Suggested Tags
* Custom Tags
* Multiple Tags per Note
* Tag Filtering
* Dynamic User Tags

---

## 📄 Pagination

* Infinite Scrolling
* Lazy Loading
* Backend Pagination
* Efficient Data Fetching

---

## 🎨 UI / UX

* Material Design
* Responsive Layout
* Modern Home Screen
* Empty States
* Loading Indicators
* Confirmation Dialogs
* Pull to Refresh
* Floating Action Button
* Character Counter
* Auto Focus
* Smooth Navigation

---

## 🌙 Theme

* Light Theme
* Dark Theme
* Theme Persistence
* SharedPreferences Integration

---

# 📱 Screenshots

> Add your screenshots inside the `screenshots` folder.

| Screen        | Image                          |
| ------------- | ------------------------------ |
| Splash Screen | screenshots/01_splash.png      |
| Login         | screenshots/02_login.png       |
| Register      | screenshots/03_register.png    |
| Home          | screenshots/04_home.png        |
| Create Note   | screenshots/05_create_note.png |
| Edit Note     | screenshots/06_edit_note.png   |
| Search        | screenshots/07_search.png      |
| Tags          | screenshots/08_tags.png        |
| Profile       | screenshots/09_profile.png     |
| Dark Mode     | screenshots/10_dark_mode.png   |

---

# 🚀 Tech Stack

## Frontend

* Flutter
* Dart
* Provider
* HTTP Package
* SharedPreferences
* Material Design

---

## Backend

* Node.js
* Express.js
* MongoDB
* Mongoose
* JWT Authentication
* bcrypt
* express-async-handler

---

## Database

* MongoDB Atlas / MongoDB Local

---

# 📂 Project Structure

```
Notes-App
│
├── backend
│   ├── config
│   ├── controllers
│   ├── middleware
│   ├── models
│   ├── routes
│   ├── utils
│   ├── server.js
│   └── package.json
│
├── frontend
│   ├── lib
│   ├── assets
│   ├── android
│   ├── ios
│   └── pubspec.yaml
│
├── screenshots
│
├── README.md
│
└── .env.example
```

---

# 🏗 Backend Architecture

```
Client

↓

Express Routes

↓

Authentication Middleware

↓

Controllers

↓

Models (Mongoose)

↓

MongoDB
```

---

# 📱 Frontend Architecture

```
UI

↓

Provider

↓

Services

↓

REST APIs

↓

Node.js Backend
```

---

# 🔄 Authentication Flow

```
Register/Login

↓

JWT Token Generated

↓

SharedPreferences

↓

Auto Login

↓

Protected APIs

↓

Logout
```

---

# 📚 Major Concepts Covered

* REST API Development
* CRUD Operations
* JWT Authentication
* Password Hashing
* Middleware
* MVC Architecture
* Provider State Management
* MongoDB Relationships
* MongoDB Text Indexing
* Search Optimization
* Pagination
* Debouncing
* Theme Management
* Form Validation
* Clean Architecture

---

# 🛠 Installation

## Clone Repository

```bash
git clone https://github.com/yourusername/Notes-App.git
```

---

## Backend

```bash
cd backend

npm install

npm run dev
```

---

## Frontend

```bash
cd frontend

flutter pub get

flutter run
```

---

# ⚙ Environment Variables

Create a `.env` file inside the backend folder.

Example:

```env
PORT=5000

MONGO_URI=your_mongodb_connection_string

JWT_SECRET=your_secret_key
```

---

# 📡 API Overview

## Authentication

* POST /api/auth/register
* POST /api/auth/login

---

## Notes

* GET /api/notes
* GET /api/notes/:id
* POST /api/notes
* PUT /api/notes/:id
* DELETE /api/notes/:id

---

## Tags

* GET /api/tags
* GET /api/tags/suggested

---

# 🔒 Security Features

* JWT Authentication
* Password Hashing
* Protected Routes
* Ownership Validation
* Input Validation
* Secure Password Storage

---

# 📈 Future Improvements

* Offline Support
* Rich Text Editor
* Image Attachments
* Voice Notes
* Reminder Notifications
* Markdown Support
* Export Notes to PDF
* Biometric Authentication
* Cloud Backup
* Multi-device Real-time Sync

---

# 🎯 Learning Outcomes

This project demonstrates practical experience with:

* Flutter Application Development
* Full Stack Mobile Development
* Node.js Backend Development
* Express.js REST APIs
* MongoDB Database Design
* JWT Authentication
* Provider State Management
* API Integration
* Pagination
* Search Optimization
* Clean Code Architecture
* Git & GitHub Workflow

---

# 👨‍💻 Author

**Utkarsh Raj**

### Connect with Me

* LinkedIn: *(Add your LinkedIn profile)*
* GitHub: *(Add your GitHub profile)*

---

# ⭐ Support

If you found this project helpful, consider giving it a **⭐ Star** on GitHub.
