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
    
    func downloadItems() {
        var locations: [ProductDetailModel] = []
        
        db.collection("product")
            .whereField("imageURL", isEqualTo: "https://firebasestorage.googleapis.com:443/v0/b/wallet-165a4.appspot.com/o/images%2F2023-03-15%2012:52:49.jpg?alt=media&token=41931010-1835-44ef-8747-a014fea03b0a")
            .getDocuments(completion: {(querySnapShot, err)in
                if let err = err{
                    print("error getting documents : \(err)")
                }else{
                    print("Data is downloarded.")
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
                                                       pPrice: document.data()["pPrice"] as! Int
                                                    )
                            
                        locations.append(query)
                    }
                    self.delegate.itemDownLoaded(items: locations)
                }
            })
            
    }
}
