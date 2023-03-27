//
//  DetailViewModel.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/20.
//

import Foundation
import Firebase

protocol DetailModelProtocal {
    func itemDownLoaded(items: [ProductDetailModel])
}

class SelectDetailData {
    var delegate: DetailModelProtocal!
    let db = Firestore.firestore()
    
    func downloadItems(imageURL: String) {
        var locations: [ProductDetailModel] = []
        
        db.collection("product")
            .whereField("imageURL", isEqualTo: imageURL)
            .getDocuments(completion: {(querySnapShot, err)in
                if let err = err{
                    print("error getting documents : \(err)")
                }else{
                    print("Data is downloarded2.")
                    for document in querySnapShot!.documents{
                        guard let data = document.data()["imageURL"] else {return}
                        print("\(document.documentID) => \(data)")
                       
                        let query = ProductDetailModel(pBrand: document.data()["pBrand"] as! String,
                                                       pColor: document.data()["pColor"] as! String,
                                                       pName: document.data()["pName"] as! String,
                                                       pMaterial: document.data()["pMaterial"] as! String,
                                                       pSize: document.data()["pSize"] as! String,
                                                       pImageURL: document.data()["imageURL"] as! String,
                                                       pContent: document.data()["pContent"] as! String,
                                                       pPrice: document.data()["pPrice"] as! String,
                                                       pTitle: document.data()["pTitle"] as! String,
                                                       pTime: document.data()["pTime"] as! String,
                                                       pDetailContent: document.data()["pDetailContent"] as! String,
                                                       pState: document.data()["pState"] as! String,
                                                       userEmail: document.data()["userEmail"] as! String,
                                                       userNickName: document.data()["userNickName"] as! String,
                                                       docId: document.documentID,
                                                       uid: document.data()["userId"] as! String,
                                                       profileImg: document.data()["profileImg"] as! String
                                                    )
                            print("query: \(query)")
                        locations.append(query)
                    }
                    self.delegate.itemDownLoaded(items: locations)
                }
            })
            
    }
    
    func downloadItems2(docId: String) {
        var locations: [ProductDetailModel] = []
        
        db.collection("product")
            .document(docId)
            .getDocument(completion: {(querySnapShot, err)in
                if let err = err{
                    print("error getting documents : \(err)")
                }else{
                    print("Data is downloarded2.")
//                    for document in querySnapShot!.documents{
                    
                    let query = ProductDetailModel(pBrand: querySnapShot!.data()!["pBrand"] as! String,
                                                   pColor: querySnapShot!.data()!["pColor"] as! String,
                                                   pName: querySnapShot!.data()!["pName"] as! String,
                                                   pMaterial: querySnapShot!.data()!["pMaterial"] as! String,
                                                   pSize: querySnapShot!.data()!["pSize"] as! String,
                                                   pImageURL: querySnapShot!.data()!["imageURL"] as! String,
                                                   pContent: querySnapShot!.data()!["pContent"] as! String,
                                                   pPrice: querySnapShot!.data()!["pPrice"] as! String,
                                                   pTitle: querySnapShot!.data()!["pTitle"] as! String,
                                                   pTime: querySnapShot!.data()!["pTime"] as! String,
                                                   pDetailContent: querySnapShot!.data()!["pDetailContent"] as! String,
                                                   pState: querySnapShot!.data()!["pState"] as! String,
                                                   userEmail: querySnapShot!.data()!["userEmail"] as! String,
                                                   userNickName: querySnapShot!.data()!["userNickName"] as! String,
                                                   docId: querySnapShot!.documentID,
                                                   uid: querySnapShot!.data()!["userId"] as! String,
                                                   profileImg: querySnapShot!.data()!["profileImg"] as! String
                                                )
                            print("query: \(query)")
                        locations.append(query)
//                    }
                    self.delegate.itemDownLoaded(items: locations)
                }
            })
            
    }
    
}
