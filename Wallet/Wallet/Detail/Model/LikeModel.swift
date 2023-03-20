//
//  LIkeModel.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/21.
//

import Foundation

class LikeModel {
    var docId: String
    var like: String

    init(docId: String, like: String) {
        self.docId = docId
        self.like = like
    }
}
