import SwiftUI
import PhotosUI

struct ChatView: View {
    @StateObject private var chatService: ChatService
    @State private var messageText = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var showConnectionOptions = false
    
    init(currentUser: AuthUser) {
        _chatService = StateObject(wrappedValue: ChatService(currentUser: currentUser))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Connection Status Bar
                connectionStatusBar
                
                // Messages List
                messagesList
                
                // Message Input
                messageInputView
            }
            .navigationTitle("BANA Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Disconnect") {
                        chatService.disconnect()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Connect") {
                        showConnectionOptions = true
                    }
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showConnectionOptions) {
                ConnectionOptionsView(chatService: chatService)
            }
        }
    }
    
    private var connectionStatusBar: some View {
        HStack {
            Circle()
                .fill(chatService.isConnected ? Color.green : Color.red)
                .frame(width: 8, height: 8)
            
            Text(chatService.isConnected ? "Connected" : "Disconnected")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if chatService.isHosting {
                Text("Hosting")
                    .font(.caption)
                    .foregroundColor(.blue)
            } else if chatService.isJoining {
                Text("Searching...")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
    
    private var messagesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(chatService.messages) { message in
                    MessageBubble(message: message, isFromCurrentUser: message.senderId == chatService.currentUser.id)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
    
    private var messageInputView: some View {
        HStack(spacing: 12) {
            // Image Picker Button
            PhotosPicker(selection: $selectedImage, matching: .images) {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .onChange(of: selectedImage) { _, item in
                Task {
                    if let data = try? await item?.loadTransferable(type: Data.self) {
                        chatService.sendImage(data)
                    }
                }
            }
            
            // Message Text Field
            TextField("Type a message...", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    sendMessage()
                }
            
            // Send Button
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.systemGray4)),
            alignment: .top
        )
    }
    
    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }
        
        chatService.sendMessage(trimmedMessage)
        messageText = ""
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isFromCurrentUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(isFromCurrentUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(message.senderName)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(formatTimestamp(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !isFromCurrentUser {
                Spacer()
            }
        }
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ConnectionOptionsView: View {
    @ObservedObject var chatService: ChatService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Connect to Peers")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Choose how you want to connect with other BANA members")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Connection Options
                VStack(spacing: 16) {
                    // Host a Chat
                    Button(action: {
                        chatService.startHosting()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .font(.title2)
                            
                            VStack(alignment: .leading) {
                                Text("Host a Chat")
                                    .font(.headline)
                                Text("Let others join your chat room")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Join a Chat
                    Button(action: {
                        chatService.startJoining()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                            
                            VStack(alignment: .leading) {
                                Text("Join a Chat")
                                    .font(.headline)
                                Text("Find and join existing chat rooms")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .navigationTitle("Connection Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ChatView(currentUser: AuthUser(
        id: "preview",
        email: "preview@example.com",
        name: "Preview User",
        provider: .google,
        profileImageURL: nil
    ))
}
