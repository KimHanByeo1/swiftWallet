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
    var pPrice: Int
    
    init(pBrand: String, pColor: String, pName: String, pMaterial: String, pSize: String, pImageURL: String, pContent: String, pPrice: Int) {
        self.pBrand = pBrand
        self.pColor = pColor
        self.pName = pName
        self.pMaterial = pMaterial
        self.pSize = pSize
        self.pImageURL = pImageURL
        self.pContent = pContent
        self.pPrice = pPrice
    }
}
