//
//  DatabaseManager.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func test(){
        database.child("foo").setValue(["something": true])
    }
}
