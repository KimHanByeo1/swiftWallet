//
//  ProfileUpdateModel.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/22.
//

import Foundation
import Firebase

class ProfileUpdataModel{
    
    let db = Firestore.firestore()

    func ProfileUpdataItems(email:String, nickname:String, profileImage:String) -> Bool{
        var status: Bool = true

        db.collection("users").document(email).updateData([
            "nickname" : nickname,
            "profileImage" : profileImage
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

