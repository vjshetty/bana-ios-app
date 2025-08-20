import Foundation
import MultipeerConnectivity
import Combine

// MARK: - Chat Models
struct ChatMessage: Identifiable, Codable {
    var id = UUID()
    let senderId: String
    let senderName: String
    let content: String
    let timestamp: Date
    let messageType: MessageType
    
    enum MessageType: String, Codable {
        case text
        case image
        case file
    }
}

struct ChatPeer: Identifiable {
    let id = UUID()
    let mcPeerID: MCPeerID
    let displayName: String
    var isConnected: Bool = false
}

// MARK: - Chat Service
class ChatService: NSObject, ObservableObject {
    @Published var connectedPeers: [ChatPeer] = []
    @Published var messages: [ChatMessage] = []
    @Published var isHosting = false
    @Published var isJoining = false
    @Published var isConnected = false
    @Published var errorMessage: String?
    
    private let serviceType = "bana-chat"
    private var session: MCSession?
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    let currentUser: AuthUser
    
    init(currentUser: AuthUser) {
        self.currentUser = currentUser
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        let peerID = MCPeerID(displayName: currentUser.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
    }
    
    // MARK: - Hosting
    func startHosting() {
        guard let session = session else { return }
        
        advertiser = MCNearbyServiceAdvertiser(peer: session.myPeerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
        
        isHosting = true
    }
    
    func stopHosting() {
        advertiser?.stopAdvertisingPeer()
        advertiser = nil
        isHosting = false
    }
    
    // MARK: - Joining
    func startJoining() {
        guard let session = session else { return }
        
        browser = MCNearbyServiceBrowser(peer: session.myPeerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
        
        isJoining = true
    }
    
    func stopJoining() {
        browser?.stopBrowsingForPeers()
        browser = nil
        isJoining = false
    }
    
    // MARK: - Sending Messages
    func sendMessage(_ content: String) {
        guard let session = session, !session.connectedPeers.isEmpty else {
            errorMessage = "No peers connected to send message"
            return
        }
        
        let message = ChatMessage(
            senderId: currentUser.id,
            senderName: currentUser.name,
            content: content,
            timestamp: Date(),
            messageType: .text
        )
        
        do {
            let data = try JSONEncoder().encode(message)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            
            // Add message to local messages
            DispatchQueue.main.async {
                self.messages.append(message)
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to send message: \(error.localizedDescription)"
            }
        }
    }
    
    func sendImage(_ imageData: Data) {
        guard let session = session, !session.connectedPeers.isEmpty else {
            errorMessage = "No peers connected to send image"
            return
        }
        
        let message = ChatMessage(
            senderId: currentUser.id,
            senderName: currentUser.name,
            content: "Image",
            timestamp: Date(),
            messageType: .image
        )
        
        do {
            let messageData = try JSONEncoder().encode(message)
            let combinedData = messageData + imageData
            
            try session.send(combinedData, toPeers: session.connectedPeers, with: .reliable)
            
            DispatchQueue.main.async {
                self.messages.append(message)
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to send image: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Connection Management
    func disconnect() {
        session?.disconnect()
        stopHosting()
        stopJoining()
        
        DispatchQueue.main.async {
            self.connectedPeers.removeAll()
            self.isConnected = false
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - MCSessionDelegate
extension ChatService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                let peer = ChatPeer(mcPeerID: peerID, displayName: peerID.displayName, isConnected: true)
                if !self.connectedPeers.contains(where: { $0.mcPeerID == peerID }) {
                    self.connectedPeers.append(peer)
                }
                self.isConnected = true
                
            case .notConnected:
                self.connectedPeers.removeAll { $0.mcPeerID == peerID }
                if self.connectedPeers.isEmpty {
                    self.isConnected = false
                }
                
            case .connecting:
                break
                
            @unknown default:
                break
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let message = try JSONDecoder().decode(ChatMessage.self, from: data)
            
            DispatchQueue.main.async {
                self.messages.append(message)
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to decode message: \(error.localizedDescription)"
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Handle stream data if needed
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Handle file transfer progress
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Handle completed file transfer
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension ChatService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Auto-accept invitations for simplicity
        invitationHandler(true, session)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension ChatService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        // Auto-invite found peers
        browser.invitePeer(peerID, to: session!, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // Handle lost peer
    }
}
