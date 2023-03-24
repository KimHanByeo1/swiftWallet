//
//  ChannelViewModel.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/24.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol ChannelViewModelProtocol{
    func itemDownLoaded(items: [Channel])
}

class downloadData{
    var delegate: ChannelViewModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems(myEmail: String){
        var items : [Channel] = []
        
        db.collection("chatrooms").getDocuments(completion: {(querySnapShot, err) in
            
//            if let err = err{
//                print("error chatrooms download items : \(err)")
//            }else{
                for doc in querySnapShot!.documents {
                    
                    print(doc.data()
                    
                    let chat = Channel(myEmail: doc.data()["me"] as! String, otherEmail: doc.data()["other"] as! String, otherName: doc.data()["otherName"] as! String)
                    
                    if chat.myEmail == myEmail || chat.otherEmail == myEmail{
                        items.append(chat)
                    }
                    
                    print(items)
                }
                self.delegate.itemDownLoaded(items: items)
//            }
        }
    )}
}

