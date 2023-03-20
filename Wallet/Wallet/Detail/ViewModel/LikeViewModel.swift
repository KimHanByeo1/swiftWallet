//
//  LikeModel.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/20.
//

import Foundation
import Firebase

protocol SelectDocIdModelProtocal {
    func SelectDocId(items: [LikeModel])
}

class LikeViewModel {
    var delegate: SelectDocIdModelProtocal!
    let db = Firestore.firestore()
    
    func insesrtItems(uid: String, code: String, like: String) {
        
        db.collection("users")
            .document(uid)
            .collection("like")
            .addDocument(data: [
            "code": code,
            "like": like
        ])
        
    }
    
    func SelectDocId(imageURL: String, uid: String) {
        var locations: [LikeModel] = []
        
        db.collection("users")
            .document(uid)
            .collection("like")
            .whereField("code", isEqualTo: imageURL)
            .getDocuments(completion: {(querySnapShot, err)in
                if let err = err{
                    print("error getting documents : \(err)")
                }else{
                    print("download Data")
                    for document in querySnapShot!.documents{
                        let query = LikeModel(docId: document.documentID,
                                              like: document.data()["like"] as! String)
                        
                        locations.append(query)
                    }
                    self.delegate.SelectDocId(items: locations)
                }
            })
    }
    
    func DeleteItems(docId: String, uid: String) {
        db.collection("users")
            .document(uid)
            .collection("like")
            .document(docId)
            .delete()
        
    }
    
}
