import Foundation
import SwiftUI

// MARK: - Authentication Models
struct AuthUser {
    let id: String
    let email: String
    let name: String
    let provider: AuthProvider
    let profileImageURL: String?
}

enum AuthProvider {
    case google
    case facebook
    case microsoft
    case instagram
}

enum AuthError: Error {
    case signInFailed
    case signOutFailed
    case userCancelled
    case networkError
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .signInFailed:
            return "Sign in failed. Please try again."
        case .signOutFailed:
            return "Sign out failed. Please try again."
        case .userCancelled:
            return "Sign in was cancelled."
        case .networkError:
            return "Network error. Please check your connection."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

// MARK: - Authentication Service
class AuthenticationService: ObservableObject {
    @Published var currentUser: AuthUser?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    static let shared = AuthenticationService()
    
    private init() {
        // For demo purposes, create a mock user
        #if DEBUG
        // Uncomment the line below to start with a mock user for testing
        // self.signInWithMockUser()
        #endif
    }
    
    // MARK: - Mock Authentication (for testing)
    func signInWithMockUser() {
        let mockUser = AuthUser(
            id: "mock_user_123",
            email: "demo@bana.org",
            name: "Demo User",
            provider: .google,
            profileImageURL: nil
        )
        
        self.currentUser = mockUser
        self.isAuthenticated = true
    }
    
    // MARK: - Google Sign In (placeholder)
    func signInWithGoogle() async throws -> AuthUser {
        await MainActor.run { isLoading = true }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        await MainActor.run { isLoading = false }
        
        // For demo purposes, create a mock user
        let mockUser = AuthUser(
            id: "google_user_123",
            email: "user@gmail.com",
            name: "Google User",
            provider: .google,
            profileImageURL: nil
        )
        
        await MainActor.run {
            self.currentUser = mockUser
            self.isAuthenticated = true
        }
        
        return mockUser
    }
    
    // MARK: - Facebook Sign In (placeholder)
    func signInWithFacebook() async throws -> AuthUser {
        await MainActor.run { isLoading = true }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        await MainActor.run { isLoading = false }
        
        // For demo purposes, create a mock user
        let mockUser = AuthUser(
            id: "facebook_user_123",
            email: "user@facebook.com",
            name: "Facebook User",
            provider: .facebook,
            profileImageURL: nil
        )
        
        await MainActor.run {
            self.currentUser = mockUser
            self.isAuthenticated = true
        }
        
        return mockUser
    }
    
    // MARK: - Microsoft Sign In (placeholder)
    func signInWithMicrosoft() async throws -> AuthUser {
        await MainActor.run { isLoading = true }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        await MainActor.run { isLoading = false }
        
        // For demo purposes, create a mock user
        let mockUser = AuthUser(
            id: "microsoft_user_123",
            email: "user@microsoft.com",
            name: "Microsoft User",
            provider: .microsoft,
            profileImageURL: nil
        )
        
        await MainActor.run {
            self.currentUser = mockUser
            self.isAuthenticated = true
        }
        
        return mockUser
    }
    
    // MARK: - Instagram Sign In (placeholder)
    func signInWithInstagram() async throws -> AuthUser {
        await MainActor.run { isLoading = true }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        await MainActor.run { isLoading = false }
        
        // For demo purposes, create a mock user
        let mockUser = AuthUser(
            id: "instagram_user_123",
            email: "user@instagram.com",
            name: "Instagram User",
            provider: .instagram,
            profileImageURL: "https://example.com/instagram-avatar.jpg"
        )
        
        await MainActor.run {
            self.currentUser = mockUser
            self.isAuthenticated = true
        }
        
        return mockUser
    }
    
    // MARK: - General Sign Out
    func signOut() async throws {
        isLoading = true
        
        // Simulate sign out delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        await MainActor.run {
            self.currentUser = nil
            self.isAuthenticated = false
            self.isLoading = false
        }
    }
}
