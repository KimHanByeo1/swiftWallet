//
//  ProfileDBModel.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/21.
//

import Foundation

struct ProfileDBModel{
    var nickname:String
    var email:String
    var profileimage:String
    
    init(nickname: String, email: String, profileimage: String) {
        self.nickname = nickname
        self.email = email
        self.profileimage = profileimage
    }
}
