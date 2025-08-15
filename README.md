# Music Finder

iOS application for browsing artists and albums using the [Discogs API](https://www.discogs.com/developers/).  
Built with Swift, Combine, and the MVVM pattern + Coordinator, SwiftUI for UI and UIKit navigation.

## 0. Analysis & Architecture
1. **Analysis & Development Process** 
    - The project was developed incrementally with attention to testability, modularity, and clear separation of concerns.
    - Key flows and data handling were designed to minimize coupling and maximize maintainability.
    
2. **Architecture**
    The app uses a Coordinator + MVVM architecture:
    - • The Coordinator is responsible for navigation between screens, and the Router is responsible for the navigation stack and presentation. Currently, only one main coordinator is used, since the app uses a single thread.гтше
    - ViewModels manage state and data transformations using Combine.
    - UI is implemented with SwiftUI for views and UIKit for navigation, allowing controlled and flexible coordination between modules.
    - Future scaling: When adding authentication or additional flows (e.g., detailed search, user profile), a main coordinator with child coordinators for each flow can be introduced to maintain modularity and separation of responsibility.
    - Data caching: At this stage, a modified LRUCache is used for storing paginated data.
    
## 1. Project Setup & Run
Follow these steps to set up and run the project locally:

1. **Requirements**:
    - Xcode 15+
    - Swift 5.9+
    - iOS 17 SDK
    - Swift Package Manager

2. **Installation**:
    - Clone the repository:
     ```bash
     git clone https://github.com/your-org/your-repo.git
     cd your-repo
     ```
   - Install dependencies:
     - Open `.xcodeproj` in Xcode and resolve packages.

3. **Authentication Setup**:
    - Open `Settings/RequestsSettings.swift`.
    - Replace the placeholder value:
     ```swift
     #warning("Put your token here")
     static let authToken = "your_token"
     ```
     with your personal token from [Discogs Developer Settings]( https://www.discogs.com/settings/developers ).

4. **Run Application**:
    - Open `YourApp.xcworkspace` in Xcode.
    - Select a simulator (e.g. iPhone 15 Pro).  
    - Press **Run** (`Cmd + R`).

---

## 2. Static Analysis

We use **SwiftLint** for static code analysis.

### Configuration
    - The configuration file is located at `Settings/.swiftlint.yml`.
    - Fo analyzing included the main source folder - MusicFinder and excluded tests and folder with mocks for #preview
    - All available SwiftLint rules are applied in this project. Only project-specific exceptions are parameterized or 
    excluded. This ensures all available SwiftLint restrictions are enforced, with only exceptions or parameterized 
    rules specific to this project.

## 3. Next Steps
    - Custom design system
    - UITests – Add full UI testing coverage to ensure stability and reliability.
    - Custom Design for iPad – Implement a tailored UI layout and experience for iPad devices.
    - OAuth Integration – Replace the static token with proper OAuth authentication using Discogs OAuth.
    - Offline mode with the local storage (SwiftData)
