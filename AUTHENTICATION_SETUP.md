# BANA App Authentication & Chat Setup Guide

This guide provides step-by-step instructions for setting up Google, Facebook, and Microsoft authentication along with peer-to-peer chat functionality in the BANA iOS app.

## Overview

The BANA app now includes comprehensive features:
- **Google Sign-In**: Using Google's OAuth 2.0
- **Facebook Login**: Using Facebook SDK
- **Microsoft Sign-In**: Using Microsoft Authentication Library (MSAL)
- **Peer-to-Peer Chat**: Using MultipeerConnectivity framework

## Authentication Setup

### 1. Google Sign-In Setup

#### Step 1: Create Google Cloud Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing project
3. Enable Google Sign-In API
4. Create OAuth 2.0 credentials

#### Step 2: Configure iOS App
1. In Google Cloud Console, add iOS app with bundle ID: `org.bana.bana`
2. Download `GoogleService-Info.plist`
3. Replace the placeholder file in `bana/GoogleService-Info.plist` with your actual configuration

#### Step 3: Update Info.plist
Replace the placeholder in `bana/Info.plist`:
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>com.googleusercontent.apps.YOUR_ACTUAL_REVERSED_CLIENT_ID</string>
</array>
```

### 2. Facebook Login Setup

#### Step 1: Create Facebook App
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app
3. Add Facebook Login product
4. Configure iOS platform

#### Step 2: Update Configuration
1. Update `bana/Info.plist` with your Facebook App ID:
```xml
<key>FacebookAppID</key>
<string>YOUR_ACTUAL_FACEBOOK_APP_ID</string>
<key>FacebookClientToken</key>
<string>YOUR_ACTUAL_FACEBOOK_CLIENT_TOKEN</string>
```

2. Update URL schemes:
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>fbYOUR_ACTUAL_FACEBOOK_APP_ID</string>
</array>
```

### 3. Microsoft Sign-In Setup

#### Step 1: Create Azure App Registration
1. Go to [Azure Portal](https://portal.azure.com/)
2. Create new app registration
3. Configure redirect URI: `msauth.org.bana.bana://auth`
4. Note the Client ID

#### Step 2: Update Configuration
Update `bana/AuthConfig.plist`:
```xml
<key>MSAL_CLIENT_ID</key>
<string>YOUR_ACTUAL_MICROSOFT_CLIENT_ID</string>
```

## Chat Features

### Peer-to-Peer Chat
The app includes a comprehensive peer-to-peer chat system using Apple's MultipeerConnectivity framework:

#### Features:
- **Local Discovery**: Automatically finds nearby BANA members
- **Host/Join**: Users can host chat rooms or join existing ones
- **Real-time Messaging**: Instant text messaging between connected peers
- **Image Sharing**: Send and receive images in chat
- **Connection Status**: Visual indicators for connection status
- **User Profiles**: Display user information in chat

#### How it Works:
1. **Hosting**: Tap "Connect" → "Host a Chat" to create a chat room
2. **Joining**: Tap "Connect" → "Join a Chat" to find and join existing rooms
3. **Messaging**: Send text messages and images to connected peers
4. **Disconnect**: Tap "Disconnect" to leave the chat

## App Features

### Authentication Flow
1. **Landing Page**: Beautiful authentication screen with three sign-in options
2. **User Profile**: Display authenticated user information in the menu
3. **Sign Out**: Secure logout functionality
4. **Error Handling**: Comprehensive error messages and recovery

### Main App Interface
1. **Web View**: BANA website integration with native navigation
2. **Burger Menu**: Slide-out navigation with user profile
3. **Chat Access**: Quick access to peer-to-peer chat
4. **Navigation**: Easy access to Home, Spotlight, Resources, and Chat

### Chat Interface
1. **Connection Options**: Host or join chat rooms
2. **Message Bubbles**: Modern chat interface with sender information
3. **Image Sharing**: Built-in photo picker for image sharing
4. **Status Indicators**: Connection and hosting status
5. **Peer List**: Display connected users

## Testing

### Authentication Testing
1. Test each authentication provider (Google, Facebook, Microsoft)
2. Verify user profile display
3. Test sign-out functionality
4. Check error handling

### Chat Testing
1. **Single Device**: Test hosting and UI
2. **Multiple Devices**: Test peer discovery and messaging
3. **Image Sharing**: Test photo selection and sending
4. **Connection Management**: Test hosting, joining, and disconnecting

## Security Considerations

1. **Authentication**: OAuth 2.0 compliant flows
2. **Chat Security**: Encrypted peer-to-peer communication
3. **Data Privacy**: No server storage of chat messages
4. **User Consent**: Clear privacy policy and terms of service

## Troubleshooting

### Common Issues

#### Authentication Issues
1. **Google Sign-In fails**: Check `GoogleService-Info.plist` configuration
2. **Facebook Login fails**: Verify App ID and Client Token in Info.plist
3. **Microsoft Sign-In fails**: Check Client ID in AuthConfig.plist

#### Chat Issues
1. **No peers found**: Ensure devices are on same network and Bluetooth is enabled
2. **Connection fails**: Check MultipeerConnectivity permissions
3. **Messages not sending**: Verify peer connection status

### Debug Steps
1. Check console logs for error messages
2. Verify all configuration files are properly set
3. Ensure internet connectivity for authentication
4. Test with different authentication providers
5. Verify MultipeerConnectivity permissions

## Production Deployment

### App Store Submission
1. Update all placeholder values with production credentials
2. Test authentication on real devices
3. Test chat functionality with multiple devices
4. Ensure proper error handling
5. Submit for App Store review

### Required Permissions
- **Network**: For authentication and web content
- **Bluetooth**: For peer-to-peer chat discovery
- **Photos**: For image sharing in chat
- **Local Network**: For peer discovery

## Support

For authentication or chat-related issues:
1. Check provider-specific documentation
2. Review console logs for detailed error messages
3. Test with minimal configuration first
4. Contact the development team for assistance

---

**Note**: This setup guide assumes you have developer accounts with Google, Facebook, and Microsoft. Follow each provider's specific documentation for detailed setup instructions.
