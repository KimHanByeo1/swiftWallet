//
//  StreamError.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/26.
//

import Foundation

enum StreamError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}

