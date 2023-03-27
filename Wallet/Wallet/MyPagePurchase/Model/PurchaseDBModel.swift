//
//  PurchaseDBModel.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/26.
//

import Foundation

struct PurchaseDBModel{
    var documentId: String
    var puchaseEmail:String // 물건 구매자 이메일
    var imageURL: String
    var pBrand: String
    var pColor: String
    var pContent: String
    var pDetailContent: String
    var pMaterial: String
    var pName: String
    var pPrice: String
    var pSize: String
    var pState: String
    var pTime: String
    var pTitle: String
    var userEmail: String
    var userId:String
    var userNickName: String
    
    init(documentId: String, puchaseEmail: String, imageURL: String, pBrand: String, pColor: String, pContent: String, pDetailContent: String, pMaterial: String, pName: String, pPrice: String, pSize: String, pState: String, pTime: String, pTitle: String, userEmail: String, userId: String, userNickName: String) {
        self.documentId = documentId
        self.puchaseEmail = puchaseEmail
        self.imageURL = imageURL
        self.pBrand = pBrand
        self.pColor = pColor
        self.pContent = pContent
        self.pDetailContent = pDetailContent
        self.pMaterial = pMaterial
        self.pName = pName
        self.pPrice = pPrice
        self.pSize = pSize
        self.pState = pState
        self.pTime = pTime
        self.pTitle = pTitle
        self.userEmail = userEmail
        self.userId = userId
        self.userNickName = userNickName
    }
    
}
