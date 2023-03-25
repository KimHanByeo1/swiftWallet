//
//  MySellDB.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/24.
//

import Foundation
import Firebase // <<<<<

protocol MySellDBProtocol{

    func itemBring(products: [MySellProductModel])
}

class MySellDB {
    var delegate: MySellDBProtocol!
    let db = Firestore.firestore()
    
    
    func sellingData(userEmail: String, pState: String) {
        var locations: [MySellProductModel] = []
        
        db.collection("product")
            .whereField("userEmail", isEqualTo: userEmail)
            .whereField("pState", isEqualTo: pState)   // 판매중 or 판매완료
            .getDocuments(completion: {(querySnapShot, err)in
                if let err = err{
                    print("error getting documents : \(err)")
                }else{
                    print("Data is downloarded2.")
                    for document in querySnapShot!.documents{
                        guard let data = document.data()["userEmail"] else {return}
                        print("\(document.documentID) => \(data)")
                       
                        let query = MySellProductModel(imageURL: document.data()["imageURL"] as! String,
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
                                                       userNickName: document.data()["userNickName"] as! String)
                            
                        locations.append(query)
                    }
                    //self.delegate.itemBring(products: locations)
                    DispatchQueue.main.async {
                        self.delegate.itemBring(products: locations)
                    }
                }
            })
            
    }
    
}
