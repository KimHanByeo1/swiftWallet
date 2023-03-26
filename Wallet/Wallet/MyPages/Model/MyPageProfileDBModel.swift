//
//  MyPageProfileDBModel.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/23.
//

import Foundation

struct MyPageProfileDBModel{
    var documentId: String
    var nickname:String
    var email:String
    var profileimage:String
    var userBalance: Int
    
    init(documentId: String, nickname: String, email: String, profileimage: String, userBalance: Int) {
        self.documentId = documentId
        self.nickname = nickname
        self.email = email
        self.profileimage = profileimage
        self.userBalance = userBalance
    }
}
