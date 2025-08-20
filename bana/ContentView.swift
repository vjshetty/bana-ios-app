 //
//  ContentView.swift
//  bana
//
//  Created by Vijeth Shetty on 7/30/25.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var authService = AuthenticationService.shared
    @State private var showMenu = false
    @State private var currentURL = "https://www.bana.org"
    @State private var currentTitle = "BANA"
    @State private var showChat = false
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                NavigationView {
                    ZStack {
                        // Main Web View
                        WebView(url: URL(string: currentURL)!, title: $currentTitle)
                            .navigationTitle(currentTitle)
                            .navigationBarTitleDisplayMode(.inline)
                        
                        // Burger Menu Button
                        VStack {
                            HStack {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showMenu.toggle()
                                    }
                                }) {
                                    Image(systemName: "line.horizontal.3")
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                        .padding()
                                        .background(Color(.systemBackground))
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                }
                                .padding(.leading)
                                
                                Spacer()
                                
                                // Chat Button
                                Button(action: {
                                    showChat = true
                                }) {
                                    Image(systemName: "message")
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                        .padding()
                                        .background(Color(.systemBackground))
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
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showMenu = false
                                    }
                                }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    // Menu Header with User Info
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("BANA")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                        
                                        Text("Bunts Association of North America")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        // User Profile
                                        if let user = authService.currentUser {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Signed in as")
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                                
                                                Text(user.name)
                                                    .font(.body)
                                                    .fontWeight(.medium)
                                                
                                                Text(user.email)
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(.top, 8)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 30)
                                    .background(Color(.systemBackground))
                                    
                                    // Menu Items
                                    VStack(spacing: 0) {
                                        MenuItem(
                                            title: "Home",
                                            icon: "house",
                                            isSelected: currentURL == "https://www.bana.org"
                                        ) {
                                            navigateTo(url: "https://www.bana.org", title: "BANA")
                                        }
                                        
                                        Divider()
                                            .padding(.horizontal, 20)
                                        
                                        MenuItem(
                                            title: "Spotlight",
                                            icon: "star",
                                            isSelected: currentURL == "https://www.bana.org/blog"
                                        ) {
                                            navigateTo(url: "https://www.bana.org/blog", title: "Spotlight")
                                        }
                                        
                                        Divider()
                                            .padding(.horizontal, 20)
                                        
                                        MenuItem(
                                            title: "Resources",
                                            icon: "folder",
                                            isSelected: currentURL == "https://www.bana.org/resources"
                                        ) {
                                            navigateTo(url: "https://www.bana.org/resources", title: "Resources")
                                        }
                                        
                                        Divider()
                                            .padding(.horizontal, 20)
                                        
                                        MenuItem(
                                            title: "Chat",
                                            icon: "message",
                                            isSelected: false
                                        ) {
                                            showChat = true
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                showMenu = false
                                            }
                                        }
                                        
                                        Divider()
                                            .padding(.horizontal, 20)
                                        
                                        MenuItem(
                                            title: "Sign Out",
                                            icon: "rectangle.portrait.and.arrow.right",
                                            isSelected: false
                                        ) {
                                            signOut()
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .frame(width: 280)
                                .background(Color(.systemBackground))
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
    
    private func navigateTo(url: String, title: String) {
        currentURL = url
        currentTitle = title
        withAnimation(.easeInOut(duration: 0.3)) {
            showMenu = false
        }
    }
    
    private func signOut() {
        Task {
            do {
                try await authService.signOut()
            } catch {
                print("Sign out error: \(error)")
            }
        }
        withAnimation(.easeInOut(duration: 0.3)) {
            showMenu = false
        }
    }
}

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
                    .foregroundColor(isSelected ? .blue : .primary)
                    .frame(width: 20)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

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
            webView.evaluateJavaScript("document.title") { result, error in
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
