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
    let myUid = Auth.auth().currentUser!.uid
    
    func downloadItems(myEmail:String){
        var userInfo : [UserInfo] = []
        
        db.collection("chatrooms").document(myUid).collection("you").getDocuments(completion: {(querySnapShot, err) in
            for doc in querySnapShot!.documents{
                let yourName = doc.documentID
                print(yourName)
            }
//            self.delegate.itemDownLoaded(items: channels)
        })
        
    }
    
}
