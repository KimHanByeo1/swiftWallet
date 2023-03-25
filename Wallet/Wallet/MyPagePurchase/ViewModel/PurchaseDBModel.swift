//
//  PurchaseDBModel.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/24.
//

import Foundation
import Firebase // <<<<<

protocol PurchaseDBModelProtocol{
    func itemDownloaded(items: [String])
    func itemBring(products: [PurchaseProductModel])
}

class PurchaseDBModel{
    
    var delegate: PurchaseDBModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems(uid: String){
        var locations: [String] = []
        
        db.collection("users")
            .document(uid)
            .collection("like")
            .getDocuments(completion: {(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents : \(err)")
                }else{
                    
                    for document in querySnapshot!.documents{
                        guard let data = document.data()["code"] else { return }
                        
                        let query = document.data()["code"] as! String
                        locations.append(query)
                    }
                    DispatchQueue.main.async {
                        self.delegate.itemDownloaded(items: locations)
                    }
                    
                }
            })
        
    }// downloadItems
    
    
    func bringProducts(code: [String]) {
        var locations: [PurchaseProductModel] = []
        
        for i in code {
            
            db.collection("product")
                .whereField("imageURL", isEqualTo: i)
                .getDocuments(completion: {(querySnapshot, err) in
                    if let err = err{
                        print("Error getting documents : \(err)")
                    }else{
                        
                        for document in querySnapshot!.documents{
                            guard let data = document.data()["imageURL"] else { return }
                            
                            let query = PurchaseProductModel(imageURL: document.data()["imageURL"] as! String,
                                                             pBrand: document.data()["pBrand"] as! String,
                                                             pColor: document.data()["pColor"] as! String,
                                                             pContent: document.data()["pContent"] as! String,
                                                             pDetailContent: document.data()["pDetailContent"] as! String,
                                                             pMaterial: document.data()["pMaterial"] as! String,
                                                             pName: document.data()["pName"] as! String,
                                                             pPrice: document.data()["pPrice"] as! String,
                                                             pSize: document.data()["pSize"] as! String,
                                                             pTime: document.data()["pTime"] as! String,
                                                             pTitle: document.data()["pTitle"] as! String,
                                                             pState: document.data()["pState"] as! String,
                                                             puchaseEmail: document.data()["puchaseEmail"] as! String
                            )
                            locations.append(query)
                        }
                        DispatchQueue.main.async {
                            self.delegate.itemBring(products: locations)
                        }
                        
 
                    }
                })
        }
    }
    
} // QueryModel
