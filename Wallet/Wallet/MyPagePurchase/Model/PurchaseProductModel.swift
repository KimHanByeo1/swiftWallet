//
//  PurchaseProductModel.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/24.
//

import Foundation

struct PurchaseProductModel{
    var imageURL: String
    var pBrand: String
    var pColor: String
    var pContent: String
    var pDetailContent: String
    var pMaterial: String
    var pName: String
    var pPrice: String
    var pSize: String
    var pTime: String
    var pTitle: String
    var pState: String
    var puchaseEmail: String
    
    init(imageURL: String, pBrand: String, pColor: String, pContent: String, pDetailContent: String, pMaterial: String, pName: String, pPrice: String, pSize: String, pTime: String, pTitle: String, pState: String, puchaseEmail: String) {
        self.imageURL = imageURL
        self.pBrand = pBrand
        self.pColor = pColor
        self.pContent = pContent
        self.pDetailContent = pDetailContent
        self.pMaterial = pMaterial
        self.pName = pName
        self.pPrice = pPrice
        self.pSize = pSize
        self.pTime = pTime
        self.pTitle = pTitle
        self.pState = pState
        self.puchaseEmail = puchaseEmail
    }
}
