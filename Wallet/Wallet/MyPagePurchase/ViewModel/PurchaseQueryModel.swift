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
    
    func downloadItems(email: String){
        var locations: [PurchaseDBModel] = []
//        let defaults = UserDefaults.standard
//        let email : String = defaults.string(forKey: "email") ?? ""
        
        db.collection("product")
//            .whereField("email", isEqualTo: puchaseEmail)
//            .getDocuments(completion: {(querySnapshot, err) in
            .getDocuments(completion: {(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents : \(err)")
                }else{
                    print("Data is downloaded.")
                    for document in querySnapshot!.documents{
                        let data = document.data()
                        
                        if let field = data["puchaseEmail"]{
                            if(field as! String == email){
                                print("PurchaseQueryModel : \(email)")
                                let query = PurchaseDBModel(documentId: document.documentID,
                                                            puchaseEmail: document.data()["puchaseEmail"] as! String,
                                                            imageURL: document.data()["imageURL"] as! String,
                                                            pBrand: document.data()["pBrand"] as! String,
                                                            pColor: document.data()["pColor"] as! String,
                                                            pContent: document.data()["pContent"] as! String,
                                                            pDetailContent: document.data()["pDetailContent"] as! String,
                                                            pMaterial: document.data()["pMaterial"] as! String,
                                                            pName: document.data()["pName"] as! String,
                                                            pPrice: document.data()["pPrice"] as! String,
                                                            pSize: document.data()["pSize"] as! String,
                                                            pState: document.data()["pState"] as! String,
                                                            pTime: document.data()["pTime"] as! String,
                                                            pTitle: document.data()["pTitle"] as! String,
                                                            userEmail: document.data()["userEmail"] as! String,
                                                            userId: document.data()["userId"] as! String,
                                                            userNickName: document.data()["userNickName"] as! String
                                )
                                locations.append(query)
                                print("hohoho")
                                print(query.puchaseEmail)
                            }
                        }
                    }

                }
                DispatchQueue.main.async {
                    self.delegate.itemDownloaded(items: locations)
                }
            })
    }
}
