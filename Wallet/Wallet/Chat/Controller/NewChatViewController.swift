//
//  NewChatViewController.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/23.
//

import UIKit
import MessageKit
import Firebase
import FirebaseDatabase
import InputBarAccessoryView

struct MessageSender:SenderType{
    var senderId: String
    var displayName: String
}

struct Message:MessageType{
    var sender: MessageKit.SenderType
    var messageId: String = ""
    var sentDate: Date
    var kind: MessageKit.MessageKind
    
    init(sender: MessageKit.SenderType, messageId: String, sentDate: Date, kind: MessageKit.MessageKind) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
    }
}


class NewChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate{
    
    var currentUser = Sender(senderId: "self", displayName: "yejin")
    
    var otherUser = Sender(senderId: "other", displayName: "aa")
    
    public var destinationUid:String?
    
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        messages.append(Message(sender: currentUser, messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello World")))
        messages.append(Message(sender: otherUser, messageId: "2", sentDate: Date().addingTimeInterval(-76400), kind: .text("a")))
        messages.append(Message(sender: currentUser, messageId: "3", sentDate: Date().addingTimeInterval(-66400), kind: .text("b")))
        messages.append(Message(sender: otherUser, messageId: "4", sentDate: Date().addingTimeInterval(-56400), kind: .text("c")))
        messages.append(Message(sender: currentUser, messageId: "5", sentDate: Date().addingTimeInterval(-46400), kind: .text("d")))
        messages.append(Message(sender: otherUser, messageId: "6", sentDate: Date().addingTimeInterval(-26400), kind: .text("e")))
       
       
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate  = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
    }
    
    func currentSender() -> MessageKit.SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
