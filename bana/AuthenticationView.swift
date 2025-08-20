import SwiftUI

struct AuthenticationView: View {
    @StateObject private var authService = AuthenticationService.shared
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    // Logo and Title
                    VStack(spacing: 20) {
                        Image(systemName: "building.2.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                            .overlay(
                                Image(systemName: "building.2")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .offset(x: 0, y: -2)
                            )

                        Text("BANA")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text("Bunts Association of North America")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        Text("Sign in to access your account")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }

                    Spacer()

                    // Authentication Buttons
                    VStack(spacing: 16) {
                        // Google Sign In
                        AuthenticationButton(
                            title: "Sign in with Google",
                            icon: "google",
                            backgroundColor: .white,
                            foregroundColor: .black,
                            borderColor: .gray.opacity(0.3)
                        ) {
                            Task {
                                await signInWithGoogle()
                            }
                        }

                        // Facebook Sign In
                        AuthenticationButton(
                            title: "Sign in with Facebook",
                            icon: "facebook",
                            backgroundColor: Color(red: 66/255, green: 103/255, blue: 178/255),
                            foregroundColor: .white,
                            borderColor: .clear
                        ) {
                            Task {
                                await signInWithFacebook()
                            }
                        }

                        // Microsoft Sign In
                        AuthenticationButton(
                            title: "Login with Windows Live",
                            icon: "microsoft",
                            backgroundColor: Color(red: 0/255, green: 120/255, blue: 215/255),
                            foregroundColor: .white,
                            borderColor: .clear
                        ) {
                            Task {
                                await signInWithMicrosoft()
                            }
                        }
                        
                        // Instagram Sign In
                        AuthenticationButton(
                            title: "Continue with Instagram",
                            icon: "instagram",
                            backgroundColor: Color(red: 225/255, green: 48/255, blue: 108/255),
                            foregroundColor: .white,
                            borderColor: .clear
                        ) {
                            Task {
                                await signInWithInstagram()
                            }
                        }
                    }
                    .padding(.horizontal, 40)

                    Spacer()

                    // Footer
                    VStack(spacing: 8) {
                        Text("By continuing, you agree to our")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        HStack(spacing: 4) {
                            Button("Terms of Service") {
                                // Open terms of service
                            }
                            .font(.caption)
                            .foregroundColor(.blue)

                            Text("and")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Button("Privacy Policy") {
                                // Open privacy policy
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 40)
                }

                // Loading overlay
                if authService.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))

                        Text("Signing in...")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .alert("Authentication Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }

    private func signInWithGoogle() async {
        do {
            _ = try await authService.signInWithGoogle()
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    private func signInWithFacebook() async {
        do {
            _ = try await authService.signInWithFacebook()
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    private func signInWithMicrosoft() async {
        do {
            _ = try await authService.signInWithMicrosoft()
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
    
    private func signInWithInstagram() async {
        do {
            _ = try await authService.signInWithInstagram()
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

struct AuthenticationButton: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Custom icon for each provider
                Group {
                    switch icon {
                    case "google":
                        // Google G logo
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            
                            Text("G")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 66/255, green: 133/255, blue: 244/255))
                        }
                    case "facebook":
                        // Facebook F logo
                        ZStack {
                            Circle()
                                .fill(Color(red: 66/255, green: 103/255, blue: 178/255))
                                .frame(width: 24, height: 24)
                            
                            Text("f")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    case "microsoft":
                        // Microsoft logo (simplified)
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                                .frame(width: 24, height: 24)
                            
                            Text("M")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0/255, green: 120/255, blue: 215/255))
                        }
                    case "instagram":
                        Image(systemName: "camera.circle.fill")
                            .foregroundColor(.white)
                    default:
                        Image(systemName: icon)
                    }
                }
                .font(.title2)
                .frame(width: 24, height: 24)

                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AuthenticationView()
}
