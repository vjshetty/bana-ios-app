# Publish BANA App to the App Store

Step-by-step guide to submit the BANA iOS app to the App Store.

---

## Prerequisites

| Requirement | Details |
|------------|--------|
| **Apple Developer Program** | Active membership ($99/year). [Enroll](https://developer.apple.com/programs/) |
| **Apple ID** | Same account used in Xcode **Signing & Capabilities** |
| **App Store Connect access** | [appstoreconnect.apple.com](https://appstoreconnect.apple.com) |
| **Privacy Policy URL** | Required for apps with sign-in (e.g. `https://www.bana.org/privacy`) |

---

## Part 1: App Store Connect setup

**→ Detailed click-by-click guide: [APPSTORE_CONNECT_HOWTO.md](APPSTORE_CONNECT_HOWTO.md)** (create app, Bundle ID, privacy URL, screenshots, description, metadata, submit).

### 1.1 Create the app record

1. Go to [App Store Connect](https://appstoreconnect.apple.com) → **My Apps**.
2. Click **+** → **New App**.
3. Fill in:
   - **Platforms**: iOS
   - **Name**: BANA (or "BANA – Bunts Association of North America")
   - **Primary Language**: English (U.S.) or your choice
   - **Bundle ID**: Select **org.bana.bana** (must match Xcode; create it under [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/identifiers/list) if missing)
   - **SKU**: e.g. `bana-2026`
   - **User Access**: Full Access (or limit to specific people)
4. Click **Create**.

### 1.2 App information (required for submission)

In your app’s page in App Store Connect:

- **App Information**
  - **Category**: e.g. Social Networking or Lifestyle
  - **Content Rights**: Check if you have rights to all content
  - **Age Rating**: Complete the questionnaire (likely 4+)
  - **Privacy Policy URL**: **Required** (e.g. `https://www.bana.org/privacy`)

- **Pricing and Availability**
  - **Price**: Free (or set a price)
  - **Countries**: Choose where the app will be available

- **App Privacy**
  - **App Privacy** section: Describe data collection (e.g. account info for sign-in, no chat data stored on servers). Follow the on-screen questions.

### 1.3 Version information (for version 1.0)

Under **App Store** tab → **1.0 Prepare for Submission**:

- **Screenshots** (required):
  - iPhone 6.7" (e.g. iPhone 15 Pro Max): at least one, up to 10
  - iPhone 6.5" (e.g. iPhone 11 Pro Max): at least one
  - iPad Pro 12.9" (if supporting iPad): at least one  
  Capture from Simulator: **File → New Screen Shot** or run on device and take screenshots. Resolutions: [Apple’s screenshot specs](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications).

- **Promotional Text** (optional): Short line shown above the description.

- **Description**: What the app does (BANA community, events, sign-in, chat, BANA 2026 Seattle, etc.).

- **Keywords**: Comma-separated, no spaces (e.g. `BANA,Bunts,community,convention,Seattle`).

- **Support URL**: e.g. `https://www.bana.org` or a contact page.

- **Marketing URL** (optional): e.g. `https://www.bana.org`.

- **Version**: Must match **Marketing Version** in Xcode (e.g. **1.0**).

- **Copyright**: e.g. `2026 Bunts Association of North America`.

- **What’s New in This Version**: e.g. “Initial release for BANA 2026 Seattle Convention.”

- **App Icon**: Already in the build (1024×1024 in the project). Do not upload again here unless Connect asks.

- **Build**: You will select the build after uploading (see Part 3).

---

## Part 2: Xcode – archive and signing

### 2.1 Confirm signing and bundle ID

1. Open **bana.xcodeproj** in Xcode.
2. Select the **bana** target → **Signing & Capabilities**.
3. Ensure:
   - **Team**: Your Apple Developer team (e.g. 3368FDB65G).
   - **Bundle Identifier**: `org.bana.bana`.
   - **Automatically manage signing**: Checked.
4. If you see signing errors, go to [developer.apple.com/account](https://developer.apple.com/account) and ensure your membership is active and the App ID **org.bana.bana** exists.

### 2.2 Create an archive (release build)

1. In Xcode, set the run destination to **Any iOS Device (arm64)** (not a simulator).
2. Menu: **Product → Archive**.
3. Wait for the archive to finish. The **Organizer** window will open with the new archive.

### 2.3 Validate the archive (recommended)

1. In Organizer, select the archive.
2. Click **Validate App**.
3. Choose **Automatically manage signing** and your team.
4. Fix any errors (e.g. missing entitlements, invalid icons) and re-archive if needed.

---

## Part 3: Upload build to App Store Connect

### Option A: From Xcode Organizer (easiest)

1. In Organizer, select the archive.
2. Click **Distribute App**.
3. Select **App Store Connect** → **Next**.
4. Select **Upload** → **Next**.
5. Keep default options (e.g. upload symbols, manage version and build number) → **Next**.
6. Select your signing certificate/profile (or automatic) → **Next**.
7. Review and click **Upload**.
8. Wait for the upload to complete. You’ll get an email when the build is “Ready to Submit” (often 5–30 minutes).

### Option B: Command line (using ExportOptions)

From the project directory:

```bash
# 1. Archive (replace with your scheme and destination)
xcodebuild -scheme bana -destination 'generic/platform=iOS' -archivePath ./build/bana.xcarchive archive

# 2. Export for App Store (uses ExportOptions-AppStore.plist)
xcodebuild -exportArchive -archivePath ./build/bana.xcarchive -exportPath ./build/export -exportOptionsPlist ExportOptions-AppStore.plist

# 3. Upload with Transporter app or altool (see below)
```

Then upload the `.ipa` from `./build/export` using the **Transporter** app (Mac App Store) or `xcrun altool` (see Apple’s docs for `altool` / App Store Connect API).

---

## Part 4: Submit for review

1. In **App Store Connect** → your app → **App Store** tab.
2. Under **1.0 Prepare for Submission**, in **Build**, click **+** and select the build you uploaded.
3. Complete any remaining required fields (contact info, export compliance, etc.).
4. Click **Add for Review** (or **Submit for Review**).
5. Answer **Export Compliance**, **Advertising Identifier**, **Content Rights**, etc., as needed.
6. Submit. Status will change to **Waiting for Review**, then **In Review**. You’ll get an email when it’s approved or if changes are requested.

---

## Quick checklist before submit

- [ ] Apple Developer Program active
- [ ] Bundle ID **org.bana.bana** created and used in Xcode
- [ ] App record created in App Store Connect with correct Bundle ID
- [ ] Privacy Policy URL set (required for sign-in)
- [ ] Screenshots added for required device sizes
- [ ] Description, keywords, support URL, version, and “What’s New” filled in
- [ ] Archive built with **Any iOS Device** (not simulator)
- [ ] Archive validated (Organizer → Validate App)
- [ ] Build uploaded and selected in the version in App Store Connect
- [ ] Export compliance and other review questions answered
- [ ] App submitted for review

---

## Project configuration (reference)

| Setting | Value |
|--------|--------|
| Bundle Identifier | `org.bana.bana` |
| Marketing Version | 1.0 |
| Current Project Version (Build) | 1 |
| Deployment Target | iOS 18.4 |
| Signing | Automatic (Team: 3368FDB65G) |

---

## Troubleshooting

- **“No accounts with App Store Connect access”**  
  Add your Apple ID in **Xcode → Settings → Accounts** and ensure the account has App Store Connect access.

- **“Bundle ID not found”**  
  Create an App ID at [developer.apple.com/account/resources/identifiers](https://developer.apple.com/account/resources/identifiers/list) with identifier `org.bana.bana`.

- **“Missing compliance” or “Invalid Icon”**  
  Fix issues reported in **Validate App** and re-archive.

- **Build not appearing in App Store Connect**  
  Wait 5–30 minutes and refresh. Check email for processing errors. Ensure the build was uploaded for **App Store Connect** (not Ad Hoc/Enterprise).

---

*For more on App Store guidelines and submission, see [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) and [App Store Connect Help](https://help.apple.com/app-store-connect/).*
