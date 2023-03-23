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
                    print("Data is downloaded.")
                    for document in querySnapshot!.documents{
                        guard let data = document.data()["code"] else { return }
                        print("\(document.documentID) => \(data)")
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
        var locations: [LikeProductModel] = []
        print(code)
        for i in code {
            print("codie")
            print(i)
            db.collection("product")
                .whereField("imageURL", isEqualTo: i)
                .getDocuments(completion: {(querySnapshot, err) in
                    if let err = err{
                        print("Error getting documents : \(err)")
                    }else{
                        print("Data is downloaded.")
                        for document in querySnapshot!.documents{
                            guard let data = document.data()["imageURL"] else { return }
                            print("\(document.documentID) => \(data)")
                            print("여기")
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
    
} // QueryModel

