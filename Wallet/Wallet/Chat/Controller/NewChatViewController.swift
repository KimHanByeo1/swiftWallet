//
//  NewChatViewController.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/23.
//

import UIKit
import MessageKit
import Firebase
import FirebaseFirestore
import InputBarAccessoryView

class NewChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    
    var currentUser = Sender(senderId: "self", displayName: "yejin")
    
    var otherUser = Sender(senderId: "other", displayName: "aa")
    
    lazy var messageList: [MockMessage] = []
    
    public var destinationUid:String?
    
    let firebaseDB = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
         readMessages()


//        messageList.append(MockMessage(text: "asd", user: Sender(senderId: "asd", displayName: "asd"), messageId: "asd", date: Date(timeIntervalSinceNow: 11111)))
//        messages.append(Message(sender: otherUser, messageId: "2", sentDate: Date().addingTimeInterval(-76400), kind: .text("a")))
//        messages.append(Message(sender: currentUser, messageId: "3", sentDate: Date().addingTimeInterval(-66400), kind: .text("b")))
//        messages.append(Message(sender: otherUser, messageId: "4", sentDate: Date().addingTimeInterval(-56400), kind: .text("c")))
//        messages.append(Message(sender: currentUser, messageId: "5", sentDate: Date().addingTimeInterval(-46400), kind: .text("d")))
//        messages.append(Message(sender: otherUser, messageId: "6", sentDate: Date().addingTimeInterval(-26400), kind: .text("e")))
       
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate  = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        configureMessageInputBar()
        
    } // viewDidLoad

    func readMessages(){
        firebaseDB.collection("chatrooms").document(self.currentUser.senderId).collection("you").document(otherUser.displayName).collection("Messages").order(by: "sentDate", descending: true).addSnapshotListener({(querySnapShot, err) in
            guard let querySnapShot = querySnapShot else { return }

            querySnapShot.documentChanges.forEach { change in
                switch change.type {
                case .added:
                    print("added")
                    let text = change.document.data()["message"] as! String
                    let user = Sender(senderId: change.document.data()["sender"] as! String, displayName: change.document.data()["senderName"] as! String)
                    let messageId = change.document.data()["sender"] as! String
                    let timestamp = change.document.data()["sentDate"] as! Timestamp

                    let date =  Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))

                    print(user.senderId)

                    self.messageList.append(MockMessage(text: text, user: user, messageId: messageId, date: date))
                    print(user)
                    self.messagesCollectionView.reloadData()
//                    print(self.messageList)

//                    print(change.document.data()["message"] as! String)
                case .modified:
                    
                    print("modified")
                    
                case .removed:
                    print("removed")
                }
            }

        })
        
    }
    
    //MockMessage(messageId: "01B56FA0-870A-4612-A0A9-8805BDD6E770", sentDate: 2023-03-26 06:45:39 +0000, kind: MessageKit.MessageKind.text("Qwewq"), user: Wallet.Sender(senderId: "aaa@aaa.aaa", displayName: "aaa"))
    
    func insertMessage(_ message: MockMessage, _ realMessage : String) {
    
        firebaseDB.collection("chatrooms").document(currentUser.senderId).collection("you").document(otherUser.displayName).setData(["yourId":otherUser.senderId])
        firebaseDB.collection("chatrooms").document(otherUser.senderId).collection("you").document(currentUser.displayName).setData(["yourId":currentUser.senderId])
    
        firebaseDB.collection("chatrooms").document(currentUser.senderId).collection("you").document(otherUser.displayName).collection("Messages").document().setData(["sender":message.sender.senderId, "senderName":currentUser.displayName, "sentDate":message.sentDate, "message":realMessage])
        firebaseDB.collection("chatrooms").document(otherUser.senderId).collection("you").document(currentUser.displayName).collection("Messages").document().setData(["sender":message.sender.senderId, "senderName":otherUser.displayName, "sentDate":message.sentDate, "message":realMessage])
        self.messagesCollectionView.reloadData()


    }
    
    func isLastSectionVisible() -> Bool {
      guard !messageList.isEmpty else { return false }

      let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)

      return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }

    
    func configureMessageInputBar(){
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .purple
        messageInputBar.sendButton.setTitleColor(.purple, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.purple.withAlphaComponent(0.3),
          for: .highlighted)
    }
    
    // MessagesDatasource
    func currentSender() -> MessageKit.SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        messageList[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
//        print(messageList)
        return messageList.count
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
    private func insertNewMessage(_ message: MockMessage) {
            messageList.append(message)
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

extension NewChatViewController: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView){
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { _, range, _ in

          let substring = attributedText.attributedSubstring(from: range)
          let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
//          print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
          // fake send request task
//          sleep(1)
          DispatchQueue.main.async { [weak self] in
            inputBar.sendButton.stopAnimating()
            inputBar.inputTextView.placeholder = "Aa"
            self?.insertMessages(components)

            self?.messagesCollectionView.scrollToLastItem(animated: true)
          }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
      for component in data {
        let user = currentUser
          if let str = component as? String {
              let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
              insertMessage(message,str)
//              print(self.messageList)
          }
      }
    }
    
    
}
