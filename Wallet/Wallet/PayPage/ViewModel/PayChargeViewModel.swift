//
//  PayChargeViewModel.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/24.
//

import Foundation
import Firebase

protocol PayChargeViewModelProtocol{
    func itemDownloaded(items: [PayChargeUserModel])
}

class PayChargeViewModel{
    var delegate: PayChargeViewModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems(email: String) {
        var locations: [PayChargeUserModel] = []
        
        db.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments(completion: {(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents : \(err)")
                }else{
                    for document in querySnapshot!.documents{
                        let query = PayChargeUserModel(
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
                }
            })
    }
    
    func addPay(email: String, userBalance: Int) {
        let data: [String: Int] = ["userBalance" : userBalance]
        let query = db.collection("users").whereField("email", isEqualTo: email)

        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    let docId = document.documentID
                    self.db.collection("users").document(docId).updateData(data) { (error) in
                        if let error = error {
                            print("Error updating document: \(error)")
                        }
                    }
                }
            }
        }
    }
}
