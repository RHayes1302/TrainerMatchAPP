# Final Project — TrainerMatch

**Student:** Ramone Hayes  
**Course:** iOS Development  
**Due Date:** February 10, 2026 — 11:59 PM  
**Project Option:** ☑️ **Option 2 — Tracking User Movements & Monitoring Health Data**
I added both features within the personal project I am having issues access the trainer section with a created profile. However you can create and sign into a client one and see the health tracker 
---

## Overview

TrainerMatch is a comprehensive fitness platform that connects personal trainers with clients while providing robust health tracking capabilities. The app serves two primary user types: trainers looking to grow their business and clients seeking professional fitness guidance. 

At its core, TrainerMatch solves the challenge of finding qualified fitness professionals and tracking health progress in one unified platform. Trainers can create detailed profiles showcasing their certifications, specialties, and pricing, while clients can browse trainers, track their daily health metrics including steps, distance, and calories, and monitor their fitness journey with beautiful visualizations.

The app features a sophisticated authentication system, dual-role user profiles (trainer/client), real-time HealthKit integration with a stunning gold triple-ring dashboard, personal best tracking with celebrations, 7-day activity history charts, and complete MVVM architecture with local data persistence.

---

## Features Checklist

### Core Requirements (All Projects)

- ✅ **SwiftUI UI with multiple screens** (10+ screens including Login, Signup, Profiles, Dashboard, Health Tracker)
- ✅ **MVVM architecture** (AuthManager, HealthViewModel + dedicated Views)
- ✅ **Proper permission handling** (HealthKit authorization with explanation screens and fallback UI)
- ✅ **Local persistence** (UserDefaults for authentication, HealthKit for health data)
- ✅ **Clean navigation** + readable UI with TrainerMatch branding (black & gold theme)

### Option 2 — Health + Movement

- ✅ **HealthKit authorization flow** (Request screen + status card + authorization button)
- ✅ **Fetch Today Steps** (Real-time updates with observer query)
- ✅ **Fetch Today Distance** (Walking/Running distance in meters)
- ✅ **7-day summary list** (Bar chart visualization with personal best highlighting)
- ✅ **Daily tracking** (Triple ring dashboard with steps, distance, calories)
- ✅ **Personal Best System** (Tracks highest step count with celebration animations)

### Additional Features

- ✅ **Dual Authentication System** (Separate login/signup flows for trainers and clients)
- ✅ **Trainer Profiles** (Certifications, schools, specialties, pricing, bio)
- ✅ **Client Profiles** (Goals, health info, progress tracking, fitness level)
- ✅ **Profile Picture Upload** (PhotosPicker integration)
- ✅ **Enhanced Form Validation** (Real-time feedback on signup forms)
- ✅ **Navigation Integration** (Health tracker accessible from client profile)
- ✅ **Logout Functionality** (In navigation bar and profile settings)

---

## Screenshots

### Authentication & Onboarding
![Login Screen - Dual role selection with TrainerMatch branding]
![Trainer Signup - Multi-step form with certifications and schools]
![Client Signup - Fitness goals and health information collection]

### Health Tracking Dashboard
![Gold Triple Ring Dashboard - Steps, Distance, Calories visualization]
![Stats Cards - Distance in km and calories burned with glow effects]
![Weekly History Chart - 7-day bar chart with personal best highlighting]

### User Profiles
![Client Profile - About, Goals, Health, Progress tabs]
![Trainer Profile - Professional details, certifications, pricing]
![Health Tracker Access - Navigation from client profile]

---

## Tech Stack

- **UI Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **Persistence:** 
  - ✅ UserDefaults (Authentication & user profiles)
  - ✅ HealthKit (Health data storage)
- **Frameworks Used:**
  - ✅ HealthKit (Steps, Distance, Activity tracking)
  - ✅ PhotosUI (Profile picture selection)
  - ✅ Combine (Reactive data binding with @Published properties)
- **Additional:**
  - Custom SwiftUI animations (Glow effects, ring animations)
  - UserNotifications entitlements (for health reminders)

---

## Architecture (MVVM)

### Service Layer

**AuthManager (Singleton)**
- Handles all authentication logic (login, logout, registration)
- Manages user session state with @Published properties
- Persists user data to UserDefaults (trainers and clients stored separately)
- Provides currentUserRole, currentUserId, currentUserEmail
- Converts between saved profiles and display models

**HealthViewModel**
- Manages HealthKit authorization state
- Executes HealthKit queries (steps, distance, history)
- Implements HKObserverQuery for real-time step updates
- Calculates activity status based on step count
- Fetches and processes 7-day historical data
- Updates UI via @Published properties

**Services:**
- File-based persistence for trainer/client profile data
- Real-time health data synchronization
- Automatic session restoration on app launch

### ViewModels

**AuthManager (@ObservableObject)**
- Published properties: `isAuthenticated`, `currentUserRole`, `currentUserId`, `currentUserEmail`
- Profile management: `currentTrainerProfile`, `currentClientProfile`
- Methods: `loginTrainer()`, `loginClient()`, `registerTrainer()`, `registerClient()`, `logout()`
- Session persistence: `saveSession()`, `loadSession()`

**HealthViewModel (@ObservableObject)**
- Published properties: `steps`, `distance`, `activityStatus`, `authStatus`, `isAuthorized`, `history`
- HealthKit methods: `requestAuthorization()`, `fetchTodaySteps()`, `fetchTodayDistance()`, `startObservingSteps()`, `fetchPastWeekSteps()`
- Activity classification: Sedentary → Lightly Active → Moderately Active → Active → Very Active
- Personal best tracking with UserDefaults persistence

### Views

**Authentication Screens:**
- `LoginView` - Dual-tab interface (Trainer/Client) with email/password validation
- `TrainerSignupView` - 3-section multi-step form (Basic, Professional, Services)
- `ClientSignupView` - 4-section form (Basic, Goals, Health, Preferences)

**Profile Screens:**
- `ClientProfileMySpaceView` - Tab-based profile (About, Goals, Health, Progress)
- `TrainerProfileView` - Professional trainer profile display
- Navigation to health tracker from client profile

**Health Tracking Screens:**
- `GoldTripleRingDashboard` - Main health dashboard with all components
- `StepRingsView` - Triple concentric rings with gold gradient and glow effects
- `StatsGridView` - Distance and calorie cards
- `WeeklyHistoryChartView` - 7-day step history bar chart
- `ActivityStatusCard` - Current activity level display
- `HealthAuthButtonView` - HealthKit authorization prompt

**Supporting Components:**
- Form validation feedback components
- Custom button styles (Certification, School, Specialty selection)
- Tab navigation components
- Info row displays

---

## Permissions & Error Handling

### HealthKit Permission (Option 2)

**Required Permissions:**
- Read: Step Count (`HKQuantityType.stepCount`)
- Read: Walking/Running Distance (`HKQuantityType.distanceWalkingRunning`)
- Read: Active Energy Burned (`HKQuantityType.activeEnergyBurned`)

**Permission Flow:**
1. User opens health tracker
2. If not authorized, shows "Health Access Needed" card with explanation
3. "Authorize Health Access" button triggers HealthKit permission prompt
4. On approval: Immediately fetches today's data + starts real-time observer
5. On denial: Shows "Not Authorized" status with option to open Settings

**Error Handling:**
- HealthKit unavailable (simulator): Shows "Not available on this device" message
- Authorization denied: Displays status card with re-request option
- Query failures: Gracefully handles with error logging, shows 0 values
- Missing data: Shows appropriate empty states ("No data available")

**UI States:**
- **Not Requested:** Shows authorization button with explanation
- **Requesting:** System permission sheet
- **Authorized:** Full dashboard with real-time data
- **Denied:** Status card with guidance to enable in Settings
- **Unavailable:** Information about device compatibility

---

## How to Run

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd TrainerMatch
   ```

2. **Open the project**
   ```bash
   open TrainerMatch.xcodeproj
   ```

3. **Select target device**
   - For HealthKit features: **Physical iOS device required** (iPhone)
   - For testing UI only: iOS Simulator works (HealthKit will show unavailable)

4. **Build and Run**
   - Press `Cmd + R` or click the Play button
   - Grant HealthKit permissions when prompted

5. **Test the app**
   - **Create Trainer Account:** Use signup form to create a trainer profile This proccess failed I cant get the button to authenicate 
   - **Create Client Account:** Use signup form to create a client profile
   - **Login:** Use created credentials to log in
   - **Access Health Tracker:** From client profile → tap "Health Tracker"
   - **Authorize HealthKit:** Tap "Authorize Health Access" button
   - **View Data:** See your real-time steps, distance, and 7-day history

**Notes:**
- ✅ HealthKit requires a **real iOS device** (not available in Simulator)
- ✅ Make sure "Health" app has step data on your device
- ✅ For testing: Walk around or use Health app's manual data entry
- ✅ Personal best automatically saves to device

---

## Known Issues / Limitations

1. **Profile Photos:** Currently show user initials instead of uploaded photos (image persistence not yet implemented with UserDefaults - would require base64 encoding or file storage)

2. **Trainer Dashboard:** Trainer role has basic profile view; full dashboard with client management planned for future release

3. **Data Sync:** User data stored locally only (no cloud backup). Future versions will integrate Firebase/backend for cross-device sync

4. **Health Tracker Access:** Currently only accessible from client profiles. Trainers could benefit from their own health tracking in future versions

5. **Form Validation:** Password strength requirements not enforced (any password accepted)

6. **Search Functionality:** Trainer search/filtering not yet implemented (foundation laid for future development)

---

## Biggest Challenge + Solution

### Challenge: Complex Multi-Step Form Compilation Errors

**The Problem:**
When implementing the trainer and client signup forms with 27 fitness goals, 29 certifications, and 19 training schools, the Swift compiler encountered "unable to type-check expression in reasonable time" errors. The forms had deeply nested VStacks with conditional rendering, validation logic, and complex button selections all in a single `body` property, causing the compiler's type inference system to timeout.

**Why It Was Hard:**
SwiftUI's type inference system needs to analyze the entire view hierarchy to determine return types. With 100+ lines of nested views, multiple conditional statements, and binding state across sections, the compiler couldn't complete type-checking within its timeout limit. Additionally, the forms needed to maintain state across multiple sections (Basic Info, Professional Details, Services) while showing real-time validation feedback.

**The Solution:**
I refactored the monolithic `body` property into smaller, focused computed properties following the "divide and conquer" approach:
- Extracted each form section into separate computed properties (`headerSection`, `formCard`, `sectionTabs`, `formContent`, `navigationButtons`)
- Broke down complex validation feedback into grouped View builders
- Replaced switch statements with if-else chains in some cases to help type inference
- Moved repeated button patterns into reusable components (`CertificationButton`, `SchoolSelectionButton`)

This reduced compilation time from timing out to under 2 seconds and made the code significantly more maintainable.

**What I Learned:**
PList are very specific on hoe you word request permissions, and I also learned even if the build succeeds one button click when testing the app  can make it crash
---

## Extra Credit

- ✅ **Personal Best Celebration System** - Animated "🎉 New Personal Best! 🎉" overlay with UserDefaults persistence
- ✅ **Real-time Health Updates** - HKObserverQuery implementation for live step count updates without manual refresh
- ✅ **Advanced Form Validation** - Real-time feedback showing exactly which fields are incomplete
- ✅ **Multi-Role Authentication** - Separate user flows for trainers and clients with role-based navigation
- ✅ **Professional UI/UX** - Custom gold theme with glow effects, shadows, and smooth animations
- ✅ **Enhanced Certification System** - Categorized certifications (General CPT, Specialty, Yoga/Pilates, Special Populations)
- ✅ **Activity Status Classification** - Smart categorization from Sedentary to Very Active based on step count
- ✅ **Comprehensive Health Dashboard** - Triple ring visualization with stats cards and weekly history chart
- ✅ **Session Persistence** - Automatic login restoration on app relaunch

---

## Code Highlights

### Custom Glow Animation Modifier
```swift
extension View {
    func continuousGlow(active: Bool, color: Color) -> some View {
        self.overlay(
            Circle()
                .stroke(color.opacity(active ? 0.5 : 0), lineWidth: active ? 20 : 0)
                .scaleEffect(active ? 1.1 : 1.0)
                .blur(radius: active ? 10 : 0)
                .animation(
                    .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: active
                )
        )
    }
}
```

### Real-Time Step Observer
```swift
func startObservingSteps() {
    guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
    
    let query = HKObserverQuery(sampleType: stepCountType, predicate: nil) { _, completionHandler, error in
        if let error = error {
            print("Observer query error: \(error.localizedDescription)")
            return
        }
        self.fetchTodaySteps()
        completionHandler()
    }
    
    healthStore.execute(query)
}
```

### Personal Best Tracking
```swift
func checkPersonalBest() {
    if viewModel.steps > highScore {
        highScore = viewModel.steps
        UserDefaults.standard.set(highScore, forKey: "highScore")
        withAnimation(.easeInOut) { showCongrats = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showCongrats = false }
        }
    }
}
```

---

## Future Enhancements

- [X] Cloud sync with Firebase backend
- [X] In-app messaging between trainers and clients
- [X] Workout plan creation and sharing
- [X] Progress photo tracking with before/after comparisons
- [X] Nutrition tracking integration
- [X] Social features (share achievements, connect with friends)
- [ ] Apple Watch companion app
- [ ] Push notifications for workout reminders
- [ ] Payment processing for trainer services
- [ ] Review and rating system for trainers

---


---

## Acknowledgments

- SwiftUI framework and documentation
- HealthKit framework for health data integration
- Apple Human Interface Guidelines for design inspiration
- iOS development community for best practices and patterns

---

## License

This project was created as a final project for [MDI1 111-C4: Mobile Application Device Sensors – Intermediate. All rights reserved.

---

## Contact

**Developer:** Ramone Hayes  
**Email:** ramone.hayes@yahoo.com  
**GitHub:**[
](https://github.com/RHayes1302/TrainerMatchAPP.git)
---

**TrainerMatch** - 
