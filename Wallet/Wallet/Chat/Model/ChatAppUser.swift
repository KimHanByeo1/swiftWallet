//
//  ChatAppUser.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/21.
//

struct ChatAppUser{
    let name: String
    let emailAddress:  String
 
    var safeEmail:String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
//    let profileImage:String
}
