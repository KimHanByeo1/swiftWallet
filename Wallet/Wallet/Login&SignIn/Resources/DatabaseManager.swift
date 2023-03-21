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
    
}

// MARK: - Account Management
extension DatabaseManager{
    
    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(email).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser){
        database.child(user.safeEmail).child(user.emailAddress).setValue([
            "name": user.name,
            "email": user.emailAddress
        ])
    }
}
