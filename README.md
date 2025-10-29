# Pandar

> A simple but sleek mobile app built with **Flutter** for the Pandar assessment — enabling users to **view**, **add**, **complete**, and **delete** items in a list.

[![Flutter](https://img.shields.io/badge/Flutter-blue?logo=flutter&logoColor=white)](https://flutter.dev/)  
[![Dart](https://img.shields.io/badge/Dart-02569B?logo=dart&logoColor=white)](https://dart.dev/)

---

## 🚀 Table of Contents

- [About](#about)  
- [Features](#features)  
- [App Screenshots](#app-screenshots)  
- [Getting Started](#getting-started)  
  - [Prerequisites](#prerequisites)  
  - [Installation & Setup](#installation--setup)  
  - [How to Run](#how-to-run)  
- [Project Structure](#project-structure)  
- [Technical Decisions & Thought Process](#technical-decisions--thought-process)  
- [Challenges & Learnings](#challenges--learnings)  
- [Future Enhancements](#future-enhancements)  
- [Contact](#contact)

---

## 🧾 About

This project was created as part of the technical assessment for the **Mobile App Developer** role at **Pandar Resources**.  
The goal: build a minimal, clean, functional app that allows users to manage a list of items (e.g. tasks, products).  

- Uses local storage or a data source for persistence  
- Emphasis on code structure, readability, and user-friendly UX  
- Accompanied by documentation explaining setup, architecture, and ideas  

---

## ✅ Features

- View a list of items  
- Add a new item  
- Mark item as completed  
- Delete an item  
- Basic error-handling & input validation  
- Clean, responsive UI  

---

## 📷 App Screenshots


| Home / List View | Add Item Screen | Completed State |
|------------------|------------------|------------------|


---

## 🛠 Getting Started

### Prerequisites

- Flutter SDK installed (>= 2.0)  
- Dart  
- An emulator or physical device (iOS or Android)  
- Git (to clone this repo)  

### Installation & Setup

1. Clone the repository:  
   ```bash
   git clone https://github.com/Ekojode/pandar.git
   cd pandar
   flutter pub get
   flutter run

---

## 🧠 Technical Decisions & Thought Process

- **Why Flutter?**  
  I chose Flutter for its cross-platform capabilities, expressive UI, and rapid iteration cycle.

- **State Management / Architecture**  
  Kept it simple (e.g. `StatefulWidget` / `setState`) given the small scope. Separation of concerns: UI layer vs data/service layer.

- **Data Storage / Persistence**  
  For this project, I used a local storage/data source (e.g. JSON, local DB) to simulate persistence. This could be swapped out for a remote API in future.

- **User Experience**  
  I prioritized minimalism and clarity: clear call-to-actions (Add, Delete), feedback on completion, and validation to prevent empty entries.

---

## 🧗 Challenges & Learnings

- Managing state updates cleanly when items are marked or removed  
- Ensuring UI updates reflect data changes immediately  
- Handling edge cases (e.g. empty input, duplicates)  
- Working under time constraints to keep code readable and modular  

Through this exercise, I reinforced principles of clean architecture, UI/UX thinking, and how to build a small but real-feel app from end to end.

---

## 🔮 Future Enhancements

- Sync with a remote API or backend  
- Offline-first mode & data sync  
- Use more advanced state management (Provider, BLoC, Riverpod)  
- Add animations & transitions  
- Add editing of existing items  
- Add user authentication & personalization  

---

## 📬 Contact

If you’d like to chat, view code, or see more of my work:

- **GitHub:** [Ekojode](https://github.com/Ekojode)  
- **Email:** [ekojodeoma@gmail.com]  

---