//
//  MyPageProfileQueryModel.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/23.
//

import Foundation
import Firebase // <<<<<

protocol MyPageProfileQueryModelProtocol{
    func itemDownloaded(items: [MyPageProfileDBModel])
}

class MyPageProfileQueryModel{
    var delegate: ProfileQueryModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems(email: String) {
        var locations: [ProfileDBModel] = []
        
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments(completion: {(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents : \(err)")
                }else{
                    print("Data is downloaded.")
                    for document in querySnapshot!.documents{
                        let query = ProfileDBModel(documentId: document.documentID,
                                                   nickname: document.data()["nickname"] as! String,
                                                   email: document.data()["email"] as! String,
                                                   profileimage: document.data()["profileImage"] as! String,
                                                   userBalance: document.data()["userBalance"] as! Int
                        )
                        
                        locations.append(query)
                    }
                    DispatchQueue.main.async {
                        self.delegate.itemDownloaded(items: locations)
                    }
                    
//
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.delegate.itemDownloaded(items: locations)
                    })
                }
            })
    }
}
