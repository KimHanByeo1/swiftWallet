//
//  MainViewModel.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/20.
//

import Foundation
import Firebase

protocol QueryModelProtocol{
    func itemDownLoaded(items: [MainModel])
}

class MainSelectModel {
    var delegate: QueryModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems() {
        var locations: [MainModel] = []
        
        db.collection("product").order(by: "pTime", descending: true)
            .getDocuments(completion: {(querySnapShot, err)in
                if let err = err{
                    print("error getting documents : \(err)")
                }else{
                    for document in querySnapShot!.documents{
//                        guard let data = document.data()["imageURL"] else {return}
//                        print("\(document.documentID) => \(data)")
                       
                        let mainQuery = MainModel(
                            imageURL: document.data()["imageURL"] as! String,
                            pBrand: document.data()["pBrand"] as! String,
                            pContent: document.data()["pContent"] as! String,
                            pPrice: document.data()["pPrice"] as! String,
                            pTitle: document.data()["pTitle"] as! String,
                            pTime: document.data()["pTime"] as! String,
                            pState: document.data()["pState"] as! String
                        )
                        
                        locations.append(mainQuery)
                    }
                    self.delegate.itemDownLoaded(items: locations)
                }
            })
            
    }
    
    func searchDownloadItems(_ brand: String) {
        var locations: [MainModel] = []
        
        db.collection("product").whereField("pBrand", isEqualTo: brand)
            .order(by: "pTime", descending: true)
            .getDocuments(completion: {(querySnapShot, err)in
                if let err = err{
                    print("error getting documents : \(err)")
                }else{
                    for document in querySnapShot!.documents{
                        let mainQuery = MainModel(
                            imageURL: document.data()["imageURL"] as! String,
                            pBrand: document.data()["pBrand"] as! String,
                            pContent: document.data()["pContent"] as! String,
                            pPrice: document.data()["pPrice"] as! String,
                            pTitle: document.data()["pTitle"] as! String,
                            pTime: document.data()["pTime"] as! String,
                            pState: document.data()["pState"] as! String
                        )
                        
                        locations.append(mainQuery)
                    }
                    self.delegate.itemDownLoaded(items: locations)
                }
            })
            
    }

}
