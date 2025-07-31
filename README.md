# BANA App

A SwiftUI iOS app for the Bunts Association of North America (BANA) that provides easy access to the BANA website and its key sections.

## Features

### 🏠 Landing Page
- Renders the main BANA website (https://www.bana.org) as the app's landing page
- Full web view integration with native iOS navigation

### 🍔 Burger Menu Navigation
- Slide-out burger menu for easy navigation
- Clean, modern UI with smooth animations
- Menu header with BANA branding

### 📰 Spotlight Section
- Direct access to BANA's blog section (https://www.bana.org/blog)
- Features community stories, interviews, and updates
- Includes recent posts like:
  - Simoul Alva's design journey
  - Community obituaries and memorials
  - Regional celebrations and events

### 📚 Resources Section
- Access to BANA's resources page (https://www.bana.org/resources)
- Community resources including:
  - BANA Knowledge Hub
  - Business Directory
  - BuntRoots
  - Moving to North America guide
  - Charitable Foundation information

## Technical Implementation

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **WebKit**: Native web view integration
- **Navigation**: Custom slide-out menu with state management

### Key Components
- `ContentView`: Main app interface with navigation
- `WebView`: UIViewRepresentable wrapper for WKWebView
- `MenuItem`: Reusable menu item component
- `Info.plist`: App configuration for web content

### Features
- **Responsive Design**: Works on iPhone and iPad
- **Smooth Animations**: 0.3s ease-in-out transitions
- **Dynamic Titles**: Web page titles update automatically
- **Visual Feedback**: Selected menu items are highlighted
- **Touch Gestures**: Tap outside menu to close

## Setup Instructions

1. **Open in Xcode**: Open the `bana.xcodeproj` file
2. **Select Target**: Choose your target device or simulator
3. **Build & Run**: Press Cmd+R to build and run the app

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## Network Configuration

The app includes App Transport Security settings to allow:
- HTTPS connections to bana.org
- HTTP fallback for compatibility
- Subdomain access for bana.org

## About BANA

BANA (Bunts Association of North America) is a community organization that serves the Bunts community in North America. The app provides easy access to:

- Community news and updates
- Cultural resources and information
- Business networking opportunities
- Educational content and scholarships
- Regional events and celebrations

## Development

This app was created using SwiftUI and follows iOS design guidelines. The web view integration allows users to access the full BANA website experience while maintaining a native iOS feel.

---

*Created by Vijeth Shetty* 