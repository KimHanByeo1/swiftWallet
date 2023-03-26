//
//  MySellProductModel.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/24.
//

import Foundation


struct MySellProductModel {
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
    var userNickName: String
    
    
    
    init(imageURL: String, pBrand: String, pColor: String, pContent: String, pDetailContent: String, pMaterial: String, pName: String, pPrice: String, pSize: String, pState: String, pTime: String, pTitle: String, userEmail: String, userNickName: String) {
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
        self.userNickName = userNickName
        
    }
    
}
