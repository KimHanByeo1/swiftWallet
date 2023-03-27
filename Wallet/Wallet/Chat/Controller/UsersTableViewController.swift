//
//  UsersTableViewController.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/20.
//

import UIKit
import SnapKit
import Firebase
import FirebaseFirestore

class UsersTableViewController: UITableViewController {
    
    var array:[UserInfo] = []
    
    var chattingUser:String?
    var lastMessage:String = ""
    var chatUserId:String = ""
    
    let firebaseDB = Firestore.firestore()
    let myUid = Auth.auth().currentUser!.uid
    let myName = UserDefaults.standard.string(forKey: "nickname")
    
    @IBOutlet var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 120
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        array.removeAll()
        readData()
    }
    
    func readData(){
//        array.removeAll()
        
        firebaseDB.collection("chatrooms").document(myUid).collection("you").getDocuments(completion: {(snapShot, err) in
            for doc in snapShot!.documents{
                self.chattingUser = doc.documentID
                print(self.chattingUser as! String)
            }
            
            self.firebaseDB.collection("chatrooms").document(self.myUid).collection("you").getDocuments(completion: {(snapShot, err) in
                for doc in snapShot!.documents{
                    self.chatUserId = doc.data()["yourId"] as! String
                }
            })
            
            self.firebaseDB.collection("chatrooms").document(self.myUid).collection("you").document(self.chattingUser!).collection("Messages").order(by: "sentDate", descending: true).limit(to: 1).getDocuments(completion: {(querySnapShot, err) in
                guard let querySnapShot = querySnapShot else { return }
                for doc in querySnapShot.documents{
                    self.lastMessage = doc.data()["message"] as! String
                    print(self.lastMessage)
                }
                DispatchQueue.main.async {
                    self.array.append(UserInfo(name: self.chattingUser!, lastMessage: self.lastMessage, userId: self.chatUserId))
                    self.userTableView.reloadData()
                }
            })
        })
        print(self.array)
        
//        print(firebaseDB.collection("chatrooms").document(myUid).collection("you").document().collection("Messages").order(by: "sentDate", descending: true))
        
        
//        firebaseDB.collection("chatrooms").document(myUid).collection("you").getDocuments(completion: {(querySnapShot, err) in
//            if let err = err{
//                print("error getting documents : \(err)")
//            }else{
//                print(querySnapShot?.documents)
//                for document in querySnapShot!.documents{
//                    print(querySnapShot!.documents)
//                    print("==================")
//                    print("\(document.documentID) => \(document.data())")
////
//                }
                
//            }
//            DispatchQueue.main.async {
//
//                self.userTableView.reloadData()
//            }
//        })
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! UserTableViewCell
        
        cell.lblUserName.text = array[indexPath.row].name
        cell.lblLastMessage.text = array[indexPath.row].lastMessage
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       
        let vc = segue.destination as! NewChatViewController
        
        let cell = sender as! UserTableViewCell
        let indexpath = userTableView.indexPath(for: cell)
        
//        vc.destinationUid = array[indexpath!.row].uid
        vc.currentUser = Sender(senderId: myUid, displayName: myName!)
        vc.otherUser = Sender(senderId: array[indexpath!.row].userId, displayName: array[indexpath!.row].name)
    }

}
