//
//  MainModel.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/20.
//

import Foundation

class MainModel {
    var imageURL: String
    var pBrand: String
    var pContent: String
    var pPrice: String
    var pTitle: String
    var pTime: String
    var pState: String

    init(imageURL: String, pBrand: String, pContent: String, pPrice: String, pTitle: String, pTime: String, pState: String) {
        self.imageURL = imageURL
        self.pBrand = pBrand
        self.pContent = pContent
        self.pPrice = pPrice
        self.pTitle = pTitle
        self.pTime = pTime
        self.pState = pState
    }
    
}
