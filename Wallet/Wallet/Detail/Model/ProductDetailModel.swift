//
//  ProductDetailModel.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/20.
//

import Foundation

class ProductDetailModel {
    var pBrand: String
    var pColor: String
    var pName: String
    var pMaterial: String
    var pSize: String
    var pImageURL: String
    var pContent: String
    var pPrice: String
    var pTitle: String
    var pTime: String
    var pDetailContent: String
    var pState: String
    var userEmail: String
    var userNickName: String
    
    init(pBrand: String, pColor: String, pName: String, pMaterial: String, pSize: String, pImageURL: String, pContent: String, pPrice: String, pTitle: String, pTime: String, pDetailContent: String, pState: String, userEmail: String, userNickName: String) {
        self.pBrand = pBrand
        self.pColor = pColor
        self.pName = pName
        self.pMaterial = pMaterial
        self.pSize = pSize
        self.pImageURL = pImageURL
        self.pContent = pContent
        self.pPrice = pPrice
        self.pTitle = pTitle
        self.pTime = pTime
        self.pDetailContent = pDetailContent
        self.pState = pState
        self.userEmail = userEmail
        self.userNickName = userNickName
    }
}
