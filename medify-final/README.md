#  Medify - A Personal Medical Records Management App

A Flutter application for managing personal medical records with real-time synchronization.

## 🌟 Features

### A Beautiful UI


![Simulator Screenshot - iPhone 16 Pro - 2025-02-17 at 15 11 35-4](https://github.com/user-attachments/assets/0aa9cd43-580a-4132-9c97-12317d641cbc)


![Simulator Screenshot - iPhone 16 Pro - 2025-02-17 at 15 11 54-3](https://github.com/user-attachments/assets/faf55782-7c4e-4ed7-aa05-14cec8b5ef9c)


![Simulator Screenshot - iPhone 16 Pro - 2025-02-17 at 15 12 07-2](https://github.com/user-attachments/assets/f778ecdf-945d-4db4-8214-6760c3eef03b)




### 📱 Core Functionality
- **Secure Authentication**
  - Email & Password authentication
  - Automatic session management
  - Secure token handling
  - Protected routes

- **Medical Records Management**
  - Add and manage multiple types of medical records:
    - 🔬 Lab Reports
    - 💊 Prescriptions
    - 🏥 Medical Conditions
  - Real-time updates and synchronization
  - Detailed record view and editing
  - Chronological timeline of medical history

- **User Profile**
  - Personal information management
  - Emergency contact details
  - Blood group information
  - Allergy tracking
  - Date of birth and contact information

### 🔒 Security Features
- **Row Level Security (RLS)**
  - Secure data isolation per user
  - Protected database access
  - Encrypted data storage
  - Secure API endpoints

- **Privacy Controls**
  - User-specific data access
  - Secure data transmission
  - Protected medical information

### 💫 User Experience
- **Modern UI/UX**
  - Clean and intuitive interface
  - Material Design 3 implementation
  - Responsive layout
  - Smooth animations
  - Real-time updates

- **Data Organization**
  - Categorized medical records
  - Chronological sorting
  - Quick access to recent records
  - Easy record filtering

## 🛠 Technical Stack

### Frontend
- **Flutter**
  - State Management: Flutter Riverpod
  - Navigation: Go Router
  - UI Components: Material Design 3
  - Date Formatting: Intl Package
  - Animations: Flutter Animate

### Backend
- **Supabase**
  - Authentication
  - PostgreSQL Database
  - Real-time Subscriptions
  - Row Level Security
  - Storage Management

### Architecture
- **Feature-First Architecture**
```
lib/
├─ core/
│  ├─ constants/
│  ├─ services/
│  ├─ theme/
│  ├─ utils/
├─ features/
│  ├─ auth/
│  ├─ records/
│  ├─ profile/
│  ├─ dashboard/
├─ main.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Supabase Account
- IDE (VS Code or Android Studio recommended)

### Installation
1. Clone the repository
```bash
git clone https://github.com/yourusername/medify.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Supabase
- Create a new Supabase project
- Update `lib/core/constants/app_constants.dart` with your Supabase credentials
- Run the SQL migrations in `supabase/migrations/`

4. Run the application
```bash
flutter run
```

## 📱 Usage

### Authentication
1. Create an account using email and password
2. Verify your email address
3. Log in to access your medical records

### Managing Records
1. Use the floating action button or quick actions to add new records
2. Fill in the required information for each record type
3. View and edit records from the main dashboard
4. Pull to refresh for latest updates

### Profile Management
1. Access profile through the dashboard
2. Update personal information
3. Add emergency contacts
4. Manage allergies and medical conditions

## 🔐 Security Considerations
- All data is stored securely in Supabase
- Row Level Security ensures data isolation
- Secure authentication flow
- Protected API endpoints
- Encrypted data transmission


## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

## Submitted for
EMIDS Hackathon 2022
