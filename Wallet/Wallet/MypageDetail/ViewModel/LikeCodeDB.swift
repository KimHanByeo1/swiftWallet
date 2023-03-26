//
//  LikeCodeDB.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/22.
//

import Foundation
import Firebase // <<<<<


protocol LikeCodeDBProtocol{
    func itemDownloaded(items: [String])
    func itemLike(items: [String])
    func itemBring(products: [LikeProductModel])
    
}

class LikeCodeDB{
    
    var delegate: LikeCodeDBProtocol!
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
    
    
    func downloadLikes(uid: String){
        var items: [String] = []
        
        
        
        db.collection("users")
            .document(uid)
            .collection("like")
            .getDocuments(completion: {(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents : \(err)")
                }else{
                    
                    for document in querySnapshot!.documents{
                        guard let data = document.data()["code"] else { return }
                        
                        let query = document.data()["like"] as! String
                        
                        items.append(query)
                        
                    }
                    DispatchQueue.main.async {
                        
                        self.delegate.itemLike(items: items)
                    }
                    
                }
            })
        
    }// downloadItems
    
    
    
    func bringProducts(code: [String]) {
        var locations: [LikeProductModel] = []
        
        for i in code {
            
            db.collection("product")
                .whereField("imageURL", isEqualTo: i)
                .getDocuments(completion: {(querySnapshot, err) in
                    if let err = err{
                        print("Error getting documents : \(err)")
                    }else{
                        
                        for document in querySnapshot!.documents{
                            guard let data = document.data()["imageURL"] else { return }
                            
                            let query = LikeProductModel(imageURL: document.data()["imageURL"] as! String,
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
                                                         pState: document.data()["pState"] as! String)
                            locations.append(query)
                        }
                        DispatchQueue.main.async {
                            self.delegate.itemBring(products: locations)
                        }
                        
 
                    }
                })
        }
    }
    
    
    func DeleteItems(imageCode: String, uid: String) {
        db.collection("users")
                    .document(uid)
                    .collection("like")
                    .whereField("imageURL", isEqualTo: imageCode)
                    .whereField("like", isEqualTo: "0")
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error deleting documents: \(error.localizedDescription)")
                        } else {
                            for document in querySnapshot!.documents {
                                document.reference.delete()
                            }
                        }
                    }

        
    }
    
    func updateItems(uid: String, imageCode:String, like: String) -> Bool{
            
        var status: Bool = true
        
        db.collection("users")
                    .document(uid)
                    .collection("like")
                    .whereField("imageURL", isEqualTo: imageCode)
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error updating documents: \(error.localizedDescription)")
                        } else {
                            for document in querySnapshot!.documents {
                                document.reference.updateData([
                                    "like": like
                                ]) { error in
                                    if let error = error {
                                        print("Error updating document: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }

            
            return status

        }
    
} // QueryModel

