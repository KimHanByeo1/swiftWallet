//
//  ProductRegisterModel.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/15.
//

import Foundation
import Firebase

class ProductRegisterModel {
    
    let db = Firestore.firestore()
    func insesrtItems(wBrand: String, wMaterial: String, wColor: String, wSize: String, wName: String, wPrice: String, wContent: String, image: String, wTitle: String, wTime: String) -> Bool{
        var status: Bool = true
        
        db.collection("product").addDocument(data: [
            "pBrand" : wBrand,
            "pMaterial" : wMaterial,
            "pColor" : wColor,
            "pSize" : wSize,
            "pName" : wName,
            "pPrice" : wPrice,
            "pContent" : wContent,
            "imageURL" : image,
            "pTitle": wTitle,
            "pTime": wTime
        ]){error in
            if error != nil{
                status = false
            }else{
                status = true
            }
        }
        return status
        
    }
    
}
