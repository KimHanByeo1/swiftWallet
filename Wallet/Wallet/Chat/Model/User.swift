//
//  Users.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct User:Codable,Equatable {
    var nickname: String
    var email:String
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
        
    }
}


