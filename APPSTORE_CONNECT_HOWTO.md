# How to Set Up Your App in App Store Connect

Follow these steps in order. Use **App Store Connect** in a browser: [appstoreconnect.apple.com](https://appstoreconnect.apple.com). Log in with your Apple Developer account.

---

## Step 1: Create the Bundle ID (if you don’t have it yet)

You need an App ID with Bundle ID **org.bana.bana** before it can appear in App Store Connect.

1. Go to [developer.apple.com/account](https://developer.apple.com/account) and sign in.
2. In the left sidebar, open **Certificates, Identifiers & Profiles**.
3. Click **Identifiers**.
4. Click the **+** button (top left).
5. Select **App IDs** → **Continue**.
6. Select **App** → **Continue**.
7. Fill in:
   - **Description**: e.g. `BANA iOS App`
   - **Bundle ID**: choose **Explicit** and type: `org.bana.bana`
8. Under **Capabilities**, leave defaults (or add any your app needs, e.g. Sign in with Apple if you use it).
9. Click **Continue** → **Register**.

You can now use **org.bana.bana** when creating the app in App Store Connect.

---

## Step 2: Create the app in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com) → **My Apps**.
2. Click the **+** button (top left) → **New App**.
3. In the dialog:
   - **Platforms**: check **iOS** (uncheck others if you only have an iOS app).
   - **Name**: `BANA` (or `BANA – Bunts Association of North America` — this is the name under the icon).
   - **Primary Language**: e.g. **English (U.S.)**.
   - **Bundle ID**: open the dropdown and select **org.bana.bana**.  
     If it’s missing, finish **Step 1** above first, then refresh the page and try again.
   - **SKU**: any unique string (e.g. `bana-2026`). You’re the only one who sees this.
   - **User Access**: **Full Access** (or limit to specific users if you prefer).
4. Click **Create**.

You’ll land on the app’s main page.

---

## Step 3: Add App Information (left sidebar)

1. In the left sidebar, click **App Information** (under the **General** section).
2. Fill in:
   - **Category**: Primary e.g. **Social Networking** or **Lifestyle**; Secondary (optional).
   - **Content Rights**: Check the box if you have rights to all content in the app.
   - **Age Rating**: Click **Edit** next to Age Rating, answer the questionnaire (for BANA it’s likely **4+**), then **Done**.
   - **Privacy Policy URL**: **Required.** Enter a working URL, e.g. `https://www.bana.org/privacy`.  
     If BANA doesn’t have a page yet, use the main site `https://www.bana.org` temporarily and replace it later when you have a real privacy policy page.
3. Click **Save** (top right).

---

## Step 4: Set Pricing and Availability

1. In the left sidebar, click **Pricing and Availability**.
2. **Price**: Choose **Free** (or set a price).
3. **Availability**: Choose **Make this app available in all territories** or select specific countries.
4. Click **Save**.

---

## Step 5: Fill in App Privacy

1. In the left sidebar, click **App Privacy**.
2. Click **Get Started** (or **Edit** if you already started).
3. **Do you or your third-party partners collect data from this app?**  
   For BANA (sign-in + optional chat): usually **Yes**. Click **Yes** and continue.
4. Follow the wizard:
   - **Data types**: e.g. **Contact Info** (email/name from sign-in). Add each type you collect.
   - For each type, say whether it’s used for **Tracking** (typically **No** for BANA).
   - **Data Use**: e.g. “App functionality” (sign-in).
5. When done, click **Publish** / **Save**.

---

## Step 6: Add Version 1.0 and Metadata

1. In the left sidebar, under **App Store**, click **iOS App** (or the **1.0** version row if you already created it).
2. If you see **Prepare for Submission** or **+ Version**, create or open version **1.0**.
3. Scroll to **App Store** tab content and fill in:

   | Field | What to enter |
   |-------|-------------------------------|
   | **Screenshots** | See Step 7 below. Required before submit. |
   | **Promotional Text** (optional) | One line, e.g. *Official app for BANA 2026 Seattle.* |
   | **Description** | Full description. Example below. |
   | **Keywords** | Comma-separated, no spaces, e.g. `BANA,Bunts,community,convention,Seattle,North America` |
   | **Support URL** | e.g. `https://www.bana.org` |
   | **Marketing URL** (optional) | e.g. `https://www.bana.org` |
   | **Version** | `1.0` (must match Xcode Marketing Version) |
   | **Copyright** | e.g. `2026 Bunts Association of North America` |
   | **What’s New in This Version** | e.g. *Initial release. BANA 2026 Seattle Convention – countdown, registration, community, and more.* |

   **Example description:**

   ```text
   The official app for the Bunts Association of North America (BANA). Stay connected with the BANA community, access event information, and get ready for BANA 2026 Seattle – the 25th milestone convention at Hyatt Regency Bellevue (July 30–August 2, 2026).

   • Countdown to convention and quick access to registration and hotel
   • Spotlight and community stories
   • Resources and links to BANA.org
   • Sign in with your preferred account
   • Connect with other members (optional in-app chat)

   For 2,500+ BANA families across North America.
   ```

4. Click **Save**.

---

## Step 7: Add Screenshots (required)

Apple requires at least one screenshot per device size you support. For iPhone-only, you need **iPhone 6.7"** and **iPhone 6.5"** (and sometimes **iPhone 5.5"**). For iPhone + iPad, add the required iPad sizes too.

### Option A: Capture from Xcode Simulator

1. In Xcode, run the app on a simulator (e.g. **iPhone 16 Pro Max** for 6.7").
2. In the Simulator menu: **File → Save Screen** (or **Cmd+S**). This saves a PNG to the Desktop.
3. Check Apple’s current sizes: [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications). Typical:
   - **iPhone 6.7"**: 1290 × 2796 px
   - **iPhone 6.5"**: 1284 × 2778 px  
   If your image is different (e.g. from a different simulator), resize in Preview or another tool to match, or use a simulator that matches the size.
4. In App Store Connect, on the version page, find **Screenshots**.
5. For **iPhone 6.7" Display**, click the **+** or the screenshot area, then upload your image(s). Add at least one; you can add up to 10.
6. Repeat for **iPhone 6.5" Display** (use the same image if aspect ratio is correct, or capture from a 6.5" simulator).
7. If you support iPad, add the required iPad Pro 12.9" (and any others) the same way.

### Option B: Use one screenshot for multiple sizes

If you have one high‑resolution screenshot (e.g. 1290×2796), you can often upload it for 6.7" and then add the same file for 6.5" if the aspect ratio is close. If Connect rejects it, capture or resize to the exact size for that slot.

---

## Step 8: Select a build (after you upload from Xcode)

You can’t pick a build until one is uploaded from Xcode.

1. In Xcode: **Product → Archive** (destination: **Any iOS Device**).
2. In Organizer: **Distribute App** → **App Store Connect** → **Upload**.
3. Wait for the email from Apple that the build is “Ready to Submit” (often 5–30 minutes).
4. Back in App Store Connect, on the same version page (e.g. **1.0 Prepare for Submission**), find **Build**.
5. Click **+** next to Build, select the build you uploaded (e.g. 1.0 (1)), then **Done**.
6. Click **Save**.

---

## Step 9: Submit for review

1. On the version page, complete any remaining required items (red or warning icons).
2. Click **Add for Review** (or **Submit for Review**).
3. Answer the questions (e.g. **Export Compliance**, **Advertising Identifier**, **Content Rights**). For a typical BANA app:
   - **Export Compliance**: Often **No** (no encryption beyond standard HTTPS).
   - **Advertising Identifier**: **No** if you don’t use ads.
4. Click **Submit to App Review**.

After that, status will show **Waiting for Review** and then **In Review**. You’ll get an email when it’s approved or if more info is needed.

---

## Quick reference: where things are

| What | Where in App Store Connect |
|------|-----------------------------|
| Create app | **My Apps** → **+** → **New App** |
| Bundle ID list | **developer.apple.com** → **Identifiers** (create **org.bana.bana** here first) |
| Privacy Policy URL | **App Information** (left sidebar) |
| Description, keywords, version | **App Store** → **iOS App** → version **1.0** |
| Screenshots | Same version page → **Screenshots** |
| Build selection | Same version page → **Build** (after upload from Xcode) |
| Submit | Same version page → **Add for Review** → **Submit to App Review** |

If any step fails (e.g. Bundle ID not in the list, or a field is missing), the error message usually says which section to fix. Use this guide and [PUBLISH_APPSTORE.md](PUBLISH_APPSTORE.md) for the full flow including Xcode archive and upload.
