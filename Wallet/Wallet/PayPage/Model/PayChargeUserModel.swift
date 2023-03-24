//
//  PayChargeUserModel.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/24.
//

import Foundation

struct PayChargeUserModel{
    var nickname:String
    var email:String
    var profileimage:String
    var userBalance:Int
    
    init(nickname: String, email: String, profileimage: String, userBalance: Int) {
        self.nickname = nickname
        self.email = email
        self.profileimage = profileimage
        self.userBalance = userBalance
    }

}
