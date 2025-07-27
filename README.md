# 🏗️ Bookie | Contractor Management App

A sleek and intuitive mobile application built with **Flutter** and powered by **Supabase** backend. The Contractor Management App is designed for construction businesses and project managers to easily manage their list of contractors, track financial transactions (amounts to be received and received), and maintain an organized overview of operations.

---

## ✨ Features

- ✅ **Splash Screen with Custom Fade Animation**  
  Polished entry experience that transitions smoothly into the main dashboard.

- 👤 **Add & Manage Contractors**  
  Add contractors dynamically with a pop-up form and view them in a clean, list-based interface.

- 💸 **Track Payments**  
  For each contractor, enter "Amount to be Received" or "Amount Received", and track net balances automatically.

- 📦 **Supabase Backend Integration**  
  Data is stored and retrieved in real-time using Supabase, ensuring speed and reliability.

- 🎨 **Beautiful UI**  
  Clean and modern design with subtle shadows, spacing, and rounded elements for a pleasant UX.

- 🔁 **Navigation with Custom Page Transitions**  
  Custom fade animations between screens enhance the experience.

---

## 🆕 New Features

- 📜 **Transaction List with Color-Coded Entries**  
  Transactions marked as "Received" (`type = 2`) show in green; "Given" (`type = 1`) show in red.

- 🧮 **Auto-Calculated Totals & Net Balance Display**  
  Each contractor page displays total "Given", total "Received", and auto-calculates the **Net Total**.

- 🗂️ **Detailed Transaction Cards**  
  For "Given" transactions: show Quantity, Rate, Amount, and Description.  
  For "Received" transactions: show Amount and Description.

- 🔄 **State Refresh on Return**  
  When returning to the contractor list page, the UI refreshes to reflect newly added transactions.

- 📥 **Excel Export Feature**  
  Download all contractor transactions into an Excel sheet directly from the app with one tap.

---

## 📲 Tech Stack

- **Flutter** – Frontend UI  
- **Dart** – Programming Language  
- **Supabase** – Backend database and authentication  
- **Material Design** – UI Components and Styling

---

## 🚀 Getting Started

### Prerequisites

- Flutter installed  
- A Supabase project (get your URL and anon key)

### Installation

```bash
git clone https://github.com/your-username/contractor-management-app.git
cd contractor-management-app
flutter pub get
