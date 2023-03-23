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
                                                       userNickName: document.data()["userNickName"] as! String
                                                    )
                            
                        locations.append(query)
                    }
                    self.delegate.itemDownLoaded(items: locations)
                }
            })
            
    }
}
