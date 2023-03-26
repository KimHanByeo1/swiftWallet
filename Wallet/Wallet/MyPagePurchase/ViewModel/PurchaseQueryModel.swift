//
//  PurchaseQueryModel.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/26.
//

import Foundation
import Firebase // <<<<<

protocol PurchaseQueryModelProtocol{
    func itemDownloaded(items: [PurchaseDBModel])
}

class PurchaseQueryModel{
    var delegate: PurchaseQueryModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems(){
        var locations: [PurchaseDBModel] = []

        db.collection("product")
//            .whereField("puchaseEmail", isEqualTo: puchaseEmail)
            .getDocuments(completion: {(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents : \(err)")
                }else{
                    print("Data is downloaded.")
                    for document in querySnapshot!.documents{
                        let query = PurchaseDBModel(documentId: document.documentID,
                                                    userEmail: document.data()["userEmail"] as! String,
                                                    puchaseEmail: document.data()["puchaseEmail"] as! String,
                                                    userId: document.data()["userId"] as! String,
                                                    imageURL: document.data()["imageURL"] as! String,
                                                    pTitle: document.data()["pTitle"] as! String,
                                                    pPrice: document.data()["pPrice"] as! String)
                        
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
