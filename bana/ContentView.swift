//
//  ContentView.swift
//  bana
//
//  Root coordinator: Pre-Event (countdown, registration, community) vs Live-Event (schedule, directory, etc.).
//

import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var authService = AuthenticationService.shared
    @State private var showMenu = false
    @State private var currentURL = "https://www.bana.org"
    @State private var currentTitle = "BANA"
    @State private var showChat = false
    /// Pre-Event: when true, show Countdown Hero as home; when false, show WebView.
    @State private var isShowingPreEventHome = true

    private let convention = ConventionInfo.seattle2026
    private var phase: AppPhase { convention.appPhase }

    var body: some View {
        Group {
            if authService.isAuthenticated {
                NavigationView {
                    ZStack {
                        // Main content: Pre-Event Home (countdown) or WebView
                        mainContent
                            .navigationTitle(navigationTitle)
                            .navigationBarTitleDisplayMode(.inline)

                        // Burger + Chat overlay
                        VStack {
                            HStack {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) { showMenu.toggle() }
                                }) {
                                    Image(systemName: "line.horizontal.3")
                                        .font(.title2)
                                        .foregroundColor(BANATheme.textPrimary)
                                        .padding()
                                        .background(BANATheme.backgroundPrimary)
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                }
                                .padding(.leading)

                                Spacer()

                                Button(action: { showChat = true }) {
                                    Image(systemName: "message")
                                        .font(.title2)
                                        .foregroundColor(BANATheme.textPrimary)
                                        .padding()
                                        .background(BANATheme.backgroundPrimary)
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                }
                                .padding(.trailing)
                            }
                            .padding(.top)
                            Spacer()
                        }

                        // Side Menu
                        if showMenu {
                            Color.black.opacity(0.3)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) { showMenu = false }
                                }

                            HStack {
                                sideMenuContent
                                    .frame(width: 280)
                                    .background(BANATheme.backgroundPrimary)
                                    .offset(x: showMenu ? 0 : -280)
                                Spacer()
                            }
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .sheet(isPresented: $showChat) {
                    if let user = authService.currentUser {
                        ChatView(currentUser: user)
                    }
                }
            } else {
                AuthenticationView()
            }
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        if phase == .preEvent && isShowingPreEventHome {
            CountdownHeroView(
                convention: convention,
                onRegister: {
                    isShowingPreEventHome = false
                    navigateTo(url: convention.registrationURL, title: "Register")
                },
                onHotel: {
                    isShowingPreEventHome = false
                    navigateTo(url: convention.hotelRoomBlockURL, title: "Hotel")
                },
                onMeetCommunity: {
                    isShowingPreEventHome = false
                    navigateTo(url: "https://www.bana.org/blog", title: "Meet the Community")
                }
            )
        } else {
            WebView(url: URL(string: currentURL)!, title: $currentTitle)
        }
    }

    private var navigationTitle: String {
        if phase == .preEvent && isShowingPreEventHome {
            return convention.name
        }
        return currentTitle
    }

    private var sideMenuContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Menu Header
            VStack(alignment: .leading, spacing: 8) {
                Text("BANA")
                    .font(BANATheme.Fonts.title2)
                    .foregroundColor(BANATheme.textPrimary)

                Text("Bunts Association of North America")
                    .font(BANATheme.Fonts.caption)
                    .foregroundColor(BANATheme.textSecondary)

                if let user = authService.currentUser {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Signed in as")
                            .font(BANATheme.Fonts.caption2)
                            .foregroundColor(BANATheme.textSecondary)
                        Text(user.name)
                            .font(BANATheme.Fonts.body)
                            .fontWeight(.medium)
                        Text(user.email)
                            .font(BANATheme.Fonts.caption2)
                            .foregroundColor(BANATheme.textSecondary)
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
            .background(BANATheme.backgroundPrimary)

            // Menu Items
            VStack(spacing: 0) {
                MenuItem(
                    title: "Home",
                    icon: "house",
                    isSelected: phase == .preEvent && isShowingPreEventHome
                ) {
                    isShowingPreEventHome = true
                    withAnimation(.easeInOut(duration: 0.3)) { showMenu = false }
                }

                Divider().padding(.horizontal, 20)

                MenuItem(
                    title: "Spotlight",
                    icon: "star",
                    isSelected: currentURL == "https://www.bana.org/blog"
                ) {
                    isShowingPreEventHome = false
                    navigateTo(url: "https://www.bana.org/blog", title: "Spotlight")
                }

                Divider().padding(.horizontal, 20)

                MenuItem(
                    title: "Resources",
                    icon: "folder",
                    isSelected: currentURL == "https://www.bana.org/resources"
                ) {
                    isShowingPreEventHome = false
                    navigateTo(url: "https://www.bana.org/resources", title: "Resources")
                }

                Divider().padding(.horizontal, 20)

                MenuItem(title: "Chat", icon: "message", isSelected: false) {
                    showChat = true
                    withAnimation(.easeInOut(duration: 0.3)) { showMenu = false }
                }

                Divider().padding(.horizontal, 20)

                MenuItem(title: "Sign Out", icon: "rectangle.portrait.and.arrow.right", isSelected: false) {
                    signOut()
                }
            }
            Spacer()
        }
    }

    private func navigateTo(url: String, title: String) {
        currentURL = url
        currentTitle = title
        withAnimation(.easeInOut(duration: 0.3)) { showMenu = false }
    }

    private func signOut() {
        Task {
            do {
                try await authService.signOut()
            } catch {
                print("Sign out error: \(error)")
            }
        }
        withAnimation(.easeInOut(duration: 0.3)) { showMenu = false }
    }
}

// MARK: - Reusable menu item (to move to Core/Components later)

struct MenuItem: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? BANATheme.accent : BANATheme.textPrimary)
                    .frame(width: 20)

                Text(title)
                    .font(BANATheme.Fonts.body)
                    .foregroundColor(isSelected ? BANATheme.accent : BANATheme.textPrimary)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(isSelected ? BANATheme.accent.opacity(0.12) : Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - WebView (to move to Core/Components later)

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var title: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.title") { result, _ in
                if let title = result as? String, !title.isEmpty {
                    DispatchQueue.main.async {
                        self.parent.title = title
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
