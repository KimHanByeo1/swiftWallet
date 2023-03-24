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

class DownloadItems{
    var delegate: ChannelViewModelProtocol!
    let db = Firestore.firestore()
    let myemail = UserDefaults.standard.string(forKey: "email")
    
    func downloadItems(myEmail:String){
        var channels : [Channel] = []
        
        db.collection("chatrooms").getDocuments(completion: {(querySnapShot, err) in
            for doc in querySnapShot!.documents{
                guard let my = doc.data()["me"] as? String, let other = doc.data()["other"] as? String, let name = doc.data()["otherName"] as? String else{return}
                
                let channel = Channel(myEmail: my, otherEmail: other, otherName: name)
                
                if my == myEmail || other == myEmail{
                    channels.append(channel)
                }
            }
            self.delegate.itemDownLoaded(items: channels)
        })
        
    }
    
}
