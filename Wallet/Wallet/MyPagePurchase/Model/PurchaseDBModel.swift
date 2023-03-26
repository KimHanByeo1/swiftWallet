//
//  PurchaseDBModel.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/26.
//

import Foundation

struct PurchaseDBModel{
    var documentId: String
    var userEmail:String // 물건 등록자 이메일
    var puchaseEmail:String // 물건 구매자 이메일
    var userId:String //물건 등록자 documentId
    var imageURL:String //물건 이미지
    var pTitle:String
    var pPrice:String
    
}
