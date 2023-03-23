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
    
    var uid:String?
    var chatRoomUid:String?
    
    var comments:[ChatModel.Comment] = []
    var userInfo:UserInfo?

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
                uid!: true,
                destinationUid!:true
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
                    "from":uid!,
                    "to": destinationUid!,
                    "message": tfMessage.text!.trimmingCharacters(in: .whitespaces)
            ]
            
            Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
    }

    func checkChatRoom(){
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: {datasnapshot in
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                
                if let chatRoomdic = item.value as? [String:AnyObject]{
                    
                    let chatModel = ChatModel(JSON: chatRoomdic)
                    if chatModel?.users[self.destinationUid!]==true{
                        self.chatRoomUid = item.key
                        self.btnSend.isEnabled = true
                        self.getDestinationInfo()
                    }
                }
            }
        })
    }
    
    func getDestinationInfo(){
        Database.database().reference().child("users").child(self.destinationUid!).observeSingleEvent(of: DataEventType.value, with: {datasnapshot in
            self.userInfo = UserInfo()
            self.userInfo?.setValuesForKeys(datasnapshot.value as! [String:Any])
            self.getMessageList()
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
        
        if self.comments[indexPath.row].uid == uid{
            let view = tableView.dequeueReusableCell(withIdentifier: "myMessageCell", for: indexPath) as! MyMessageCell
            view.lblMessage.text = self.comments[indexPath.row].message
            view.lblMessage.numberOfLines = 0
            return view
        }else{
            let view = tableView.dequeueReusableCell(withIdentifier: "destinationMessageCell", for: indexPath) as! DestinationMessageCell
            view.lblUserName.text = userInfo?.name
            view.lblDestinationMessage.text = self.comments[indexPath.row].message
            view.lblDestinationMessage.numberOfLines = 0
            return view
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
    @IBOutlet weak var lblMessage: UILabel!
}

class DestinationMessageCell:UITableViewCell{
    @IBOutlet weak var lblDestinationMessage: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
}
