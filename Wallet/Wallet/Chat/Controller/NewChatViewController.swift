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


class NewChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    
    var currentUser = Sender(senderId: "self", displayName: "yejin")
    
    var otherUser = Sender(senderId: "other", displayName: "aa")
    
    public var destinationUid:String?
    
    var messages = [MessageType]()

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
    }
    
    // MessagesDatasource
    func currentSender() -> MessageKit.SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1),
                                                                 .foregroundColor: UIColor(white: 0.3, alpha: 1)])
        }

    // MessagesLayoutDelegate
    // 말풍선 위 이름 나오는 곳의 height
       func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
           return 20
       }
    
    // MessagesDisplayDelegate
    // 상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정
        // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .systemPurple : .systemGray6
    }

        func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
            return isFromCurrentSender(message: message) ? .white : .black
        }

        // 말풍선의 꼬리 모양 방향
        func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
            let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
            return .bubbleTail(cornerDirection, .curved)
        }

    //
    private func insertNewMessage(_ message: Message) {
            messages.append(message)
//            messages.sort()
            
            messagesCollectionView.reloadData()
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
