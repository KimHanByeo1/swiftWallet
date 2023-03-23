//
//  ChatViewController.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var tfMessage: UITextField!
    
    
    
    // 채팅 대상 uid
    public var destinationUid:String?
    
    var currentUser = UserDefaults.standard.string(forKey: "email")
    
    var uid:String?
    var chatRoomUid:String?
    
    var comments:[ChatModel.Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        uid = Auth.auth().currentUser?.uid
        btnSend.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        checkChatRoom()
    }
    
    
    @IBAction func btnSendmessage(_ sender: UIButton) {
        
    }
    
    // Chatting Room 생성
    @objc func createRoom(){
        let createRoomInfo:Dictionary<String,Any> = [
            "users":[
                "from": currentUser,
                "to": destinationUid
            ]
        ]
        
        if chatRoomUid == nil{
            self.btnSend.isEnabled = false
            // 방 생성 코드
            Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo, withCompletionBlock: {(err, ref) in
                if err == nil{
                    self.checkChatRoom()
                }
            })
    
        }else{
            let value: Dictionary<String,Any> = [
                    "uid":uid!,
                    "message": tfMessage.text!.trimmingCharacters(in: .whitespaces)
            ]
            
            Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
    }

    func checkChatRoom(){
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/to").queryEqual(toValue: destinationUid).observeSingleEvent(of: DataEventType.value, with: {datasnapshot in
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                
                if let chatRoomdic = item.value as? [String:AnyObject]{
                    
                    let chatModel = ChatModel(JSON: chatRoomdic)
                    if chatModel?.users[self.destinationUid!]==true{
                        self.chatRoomUid = item.key
                        self.btnSend.isEnabled = true
                        self.getMessageList()
                    }
                }
            }
        })
    }
    
    func getMessageList(){
        Database.database().reference().child("chatrooms").child(self.chatRoomUid!).child("comments").observe(DataEventType.value, with: {
            datasnapshot in
            self.comments.removeAll()
            
            for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                self.comments.append(comment!)
            }
            self.tableview.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        view.textLabel?.text = self.comments[indexPath.row].message
        
        return view
        
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

class MyMessageCell:UITableViewCell{
    
}

class DestinationMessageCell:UITableViewCell{
    
}
