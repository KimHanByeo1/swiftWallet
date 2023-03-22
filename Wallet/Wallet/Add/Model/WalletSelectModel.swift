//
//  AddModel.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/14.
//

// FireBase에서 가져온 데이터 저장하는 Field 값

import Foundation

class WalletSelectModel {
    var wBrand: String // 브랜드 이름
    var wColor: String // 상품 색상
    var wName: String // 상품 이름
    var wMaterial: String // 상품 소재
    var wDetailContent: String
    
    var wLength: Int // 길이
    var wHeight: Int // 높이
    var wWidth: Double // 너비
    var wCode: Int // 상품 코드
    
    init(wBrand: String, wColor: String, wName: String, wMaterial: String, wLength: Int, wHeight: Int, wWidth: Double, wCode: Int, wDetailContent: String) {
        self.wBrand = wBrand
        self.wColor = wColor
        self.wName = wName
        self.wMaterial = wMaterial
        self.wLength = wLength
        self.wHeight = wHeight
        self.wWidth = wWidth
        self.wCode = wCode
        self.wDetailContent = wDetailContent
    }
    
}
