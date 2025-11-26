# 🛰️ D_Zone

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com/)


**A Flutter App to Map Mobile Network DeadZones **

---

## 📖 Table of Contents

- [Project Overview](#project-overview)  
- [Features](#features)  
- [How It Works](#how-it-works)  
- [Tech Stack](#tech-stack)  
- [Installation](#installation)  
- [Usage](#usage)  
- [Contribution](#contribution)  
- [License](#license)  

---

## 🌐 Project Overview

D_Zone is a Flutter application that maps mobile network deadzones and generates reports to help ISPs improve network coverage. By crowd-sourcing deadzone data from users, it provides a transparent and interactive map of low-signal areas.

---

## ✨ Features

### 1. Sign-In & Profile
- Email/password sign-in using Firebase Authentication  
- Profile page displays username, email, and randomly assigned Gravatar  
- Sign-out functionality

### 2. Map
- Real-time Google Maps integration  
- "Report Location" button marks **current location** as a deadzone  
- All users can view reported deadzones (red markers)

### 3. Weekly Reports
- Bar graph showing the number of deadzones mapped each week  
- Helps track trends and coverage improvement

### 4. DeadZones List
- Lists all deadzones with latitude, longitude, and approximate place name

### 5. Streak
- Gamification to encourage user participation  
- Users earn streak medals based on deadzones reported

### 6. Feedback
- Floating feedback icon to collect user suggestions and improve engagement

---

## ⚙️ How It Works

1. Users sign in and access the home page  
2. Report deadzones using the **current location**  
3. Data is stored in **Firebase Firestore** for real-time updates  
4. Weekly reports and streaks provide analytics and motivation  

---

## 🛠️ Tech Stack

- **Frontend:** Flutter  
- **Backend:** Firebase (Authentication & Firestore)  
- **Maps:** Google Maps API  
- **Charts:** Flutter Charts package  

---

## 🚀 Installation

1. Clone the repository:

```bash
git clone https://github.com/bhagya518/d_zoneeee.git
cd d_zoneeee
