//
//  ProfileQueryModel.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/21.
//

import Foundation
import Firebase // <<<<<

protocol ProfileQueryModelProtocol{
    func itemDownloaded(items: [ProfileDBModel])
}

class ProfileQueryModel{
    var delegate: ProfileQueryModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems(){
        var locations: [ProfileDBModel] = []
        
        db.collection("users")
            .order(by: "email").getDocuments(completion: {(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents : \(err)")
                }else{
                    print("Data is downloaded.")
                    for document in querySnapshot!.documents{
                        guard let data = document.data()["email"] else { return }
                        print("\(document.documentID) => \(data)")
                        let query = ProfileDBModel(nickname: document.data()["nickname"] as! String,
                                                   email: document.documentID,
                                                   profileimage: document.data()["profileimage"] as! String)
                        print(query)
                        locations.append(query)
                    }
                    DispatchQueue.main.async {
                        self.delegate.itemDownloaded(items: locations)
                    }
                    
//
//                    DispatchQueue.main.async(execute: {() -> Void in
//                        self.delegate.itemDownloaded(items: locations)
//                    })
                }
            })
    }
}
