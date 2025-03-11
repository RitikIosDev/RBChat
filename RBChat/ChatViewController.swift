//
//  ChatViewController.swift
//  ChatDemo
//
//  Created by Ritik on 28/02/25.
//

import UIKit
import MessageKit
import InputBarAccessoryView

// MARK: - Chat User Model
public struct ChatUser: SenderType {
    public var senderId: String
    public var displayName: String
    
    public init(senderId: String, displayName: String) {
        self.senderId = senderId
        self.displayName = displayName
    }
}

// MARK: - Message Model
public struct ChatMessage: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

// MARK: - Chat Customization
public struct ChatCustomization {
    public static var showProfilePictures: Bool = true
    public static var messageBubbleColor: UIColor = .systemBlue
    public static var receivedMessageBubbleColor: UIColor = .lightGray
}

// MARK: - Input Bar Customization
public struct InputBarCustomization {
    public static var backgroundColor: UIColor = .white
    public static var textColor: UIColor = .black
    public static var placeholderText: String = "Type a message..."
    public static var sendButtonColor: UIColor = .blue
    public static var tintColor: UIColor = .black
    public static var cornerRadius: CGFloat = 0
    public static var borderWidth: CGFloat = 0
    public static var borderColor: CGColor = UIColor.systemGray4.cgColor
    
}

// MARK: - Send Button Customization
public struct SendButtonCustomization {
    public static var isTextButton: Bool = true
    public static var text: String = "Send"
    public static var image: UIImage? = UIImage(systemName: "paperplane")
    public static var textColor: UIColor = .white
    public static var backgroundColor: UIColor = .clear
    public static var cornerRadius: CGFloat = 5
}


// MARK: - Chat View Controller
public class ChatViewController: MessagesViewController {
    
    public var messages: [ChatMessage] = []
    public var currentUser: SenderType
    
    public init(currentUser: SenderType) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = currentUser.displayName
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        configureChatStyle()
        configureInputBar()
        loadDummyMessages()
    }
    
    func configureChatStyle() {
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        if !ChatCustomization.showProfilePictures {
            layout?.setMessageIncomingAvatarSize(.zero)
            layout?.setMessageOutgoingAvatarSize(.zero)
        }
    }
    
    func configureInputBar() {
        messageInputBar.inputTextView.backgroundColor = InputBarCustomization.backgroundColor
        messageInputBar.inputTextView.textColor = InputBarCustomization.textColor
        messageInputBar.inputTextView.placeholder = InputBarCustomization.placeholderText
        messageInputBar.inputTextView.tintColor = InputBarCustomization.tintColor
        messageInputBar.sendButton.tintColor = InputBarCustomization.sendButtonColor
        messageInputBar.inputTextView.layer.cornerRadius = InputBarCustomization.cornerRadius
        messageInputBar.inputTextView.layer.borderWidth = InputBarCustomization.borderWidth
        messageInputBar.inputTextView.layer.borderColor = InputBarCustomization.borderColor
        customizeSendButton()
    }
    
    func customizeSendButton() {
        if SendButtonCustomization.isTextButton {
            messageInputBar.sendButton.setTitle(SendButtonCustomization.text, for: .normal)
            messageInputBar.sendButton.setTitleColor(SendButtonCustomization.textColor, for: .normal)
            messageInputBar.sendButton.backgroundColor = SendButtonCustomization.backgroundColor
            messageInputBar.sendButton.layer.cornerRadius = SendButtonCustomization.cornerRadius
        } else {
            
            // Send Button as InputBarButtonItem
            let sendButton = InputBarButtonItem()
            sendButton.image = SendButtonCustomization.image
            sendButton.tintColor = SendButtonCustomization.textColor
            sendButton.setSize(CGSize(width: 35, height: 35), animated: false)
            sendButton.onTouchUpInside {_ in
                
            }
            
            let button = InputBarButtonItem()
            button.image = SendButtonCustomization.image
            button.tintColor = SendButtonCustomization.textColor
            button.setSize(CGSize(width: 35, height: 35), animated: false)
            button.onTouchUpInside {_ in
                
            }
            messageInputBar.setStackViewItems([sendButton], forStack: .right, animated: false)
        }
    }
    
    func loadDummyMessages() {
        let friend = ChatUser(senderId: "2", displayName: "Friend")
        messages.append(ChatMessage(sender: currentUser, messageId: "101", sentDate: Date(), kind: .text("Hello!")))
        messages.append(ChatMessage(sender: friend, messageId: "102", sentDate: Date(), kind: .text("Hi there!")))
        messagesCollectionView.reloadData()
    }
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    public func currentSender() -> SenderType { return currentUser }
    public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int { return messages.count }
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType { return messages[indexPath.section] }
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
    public func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
    
// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    public func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return message.sender.senderId == currentUser.senderId ? ChatCustomization.messageBubbleColor : ChatCustomization.receivedMessageBubbleColor
    }
}

    // MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = ChatMessage(sender: currentUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
        messages.append(message)
        messagesCollectionView.reloadData()
        inputBar.inputTextView.text = ""
    }
}
