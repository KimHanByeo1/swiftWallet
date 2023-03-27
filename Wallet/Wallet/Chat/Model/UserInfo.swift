//
//  UserInfo.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/22.
//

import UIKit

class UserInfo {
    var name:String
    var lastMessage:String
    var userId: String
    
    init(name: String, lastMessage: String, userId:String) {
        self.name = name
        self.lastMessage = lastMessage
        self.userId = userId
    }
}
