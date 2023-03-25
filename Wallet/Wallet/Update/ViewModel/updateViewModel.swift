//
//  updateViewModel.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/24.
//

import Foundation
import Firebase

class UpdateModel{
    let db = Firestore.firestore()
    
    func UpdateItems(docId: String, pBrand: String, pMaterial: String, pColor: String, pSize: String, pName: String, pPrice: String, pContent: String, image: String, pTitle: String, pTime: String, pDetailContent: String, nickName: String, email: String) -> Bool{
        var status: Bool = true
        
        db.collection("product").document(docId).updateData([
            "pBrand" : pBrand,
            "pMaterial" : pMaterial,
            "pColor" : pColor,
            "pSize" : pSize,
            "pName" : pName,
            "pPrice" : pPrice,
            "pContent" : pContent,
            "imageURL" : image,
            "pTitle" : pTitle,
            "pTime" : pTime,
            "pDetailContent" : pDetailContent,
            "userNickName" : nickName,
            "userEmail" : email,
            "pState": "0"
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
