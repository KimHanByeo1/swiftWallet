//
//  UserViewModel.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/20.
//

import Foundation
import Firebase
import FirebaseAuth

protocol UserModelProtocal {
    func userItemDownLoaded(items: [UserLikeModel])
}

class UserLikeData {
    let defaults = UserDefaults.standard
    
    var delegate: UserModelProtocal!
    let db = Firestore.firestore()
    
    func downloadUser(imageURL: String, uid: String) {
//        let uid = Auth.auth().currentUser!.uid
        var locations: [UserLikeModel] = []
        
        db.collection("users")
            .document(uid)
            .collection("like")
            .whereField("code", isEqualTo: imageURL)
            .getDocuments(completion: {(querySnapShot, err)in
                if let err = err{
                    print("error getting documents : \(err)")
                }else{
                    print("Data is downloarded.")
                    for document in querySnapShot!.documents{
                       
                        let query = UserLikeModel(
                            like: document.data()["like"] as! String
                        )
                        locations.append(query)
                        print("likess")
                        print(locations)
                    }
                    self.delegate.userItemDownLoaded(items: locations)
                }
            })
            
    }
}
