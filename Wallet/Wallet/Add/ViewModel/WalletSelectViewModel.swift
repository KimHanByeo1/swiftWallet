//
//  ProductSelectModel.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/14.
//

// FireBase에서 상품 상세정보 가져오기
// Flask 서버에서 return 받은 값(pCode)으로 Where 조건문을 사용하여 원하는 데이터 Select
// 가져온 데이터 ProductSelectModel에 저장

import Foundation
import Firebase

protocol QueryModelProtocal{
    func itemDownLoaded(items: [WalletSelectModel])
}

class SelectData {
    var delegate: QueryModelProtocal!
    let db = Firestore.firestore()
    
    func downloadItems() {
        var locations: [WalletSelectModel] = []
        
        db.collection("wallet")
            .whereField("wCode", isEqualTo: StaticModel.wCode)
            .getDocuments(completion: {(querySnapShot, err)in
                if let err = err{
                    print("error getting documents : \(err)")
                }else{
                    print("Data is downloarded.")
                    for document in querySnapShot!.documents{
                        guard let data = document.data()["wCode"] else {return}
                        print("\(document.documentID) => \(data)")
                       
                        let query = WalletSelectModel(
                            wBrand: document.data()["wBrand"] as! String,
                            wColor: document.data()["wColor"] as! String,
                            wName: document.data()["wName"] as! String,
                            wMaterial: document.data()["wMaterial"] as! String,
                            wLength: document.data()["wLength"] as! Int,
                            wHeight: document.data()["wHeight"] as! Int,
                            wWidth: document.data()["wWidth"] as! Double,
                            wCode: document.data()["wCode"] as! Int)
                        
                        locations.append(query)
                    }
                    self.delegate.itemDownLoaded(items: locations)
                }
            })
            
    }
}
