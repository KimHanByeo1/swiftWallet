//
//  FirebaseUserListener.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/20.
//

import Foundation
import Firebase

class FirebaseUserListener{
    static let shared = FirebaseUserListener()
    
    private init(){}
    
    func downloadAllUsersFromFirebase(completion: @escaping (_ allUsers: [User]) -> Void ) {
            
        var users: [User] = []
        
        FirebaseReference(.User).limit(to: 500).getDocuments { (querySnapshot, error) in
            
            guard let document = querySnapshot?.documents else {
                print("no documents in all users")
                return
            }
            
            let allUsers = document.compactMap { (queryDocumentSnapshot) -> User? in
                return try? queryDocumentSnapshot.data(as: User.self)
            }
            
            for user in allUsers {
                
                if User.currentId != user.email {
                    users.append(user)
                }
            }
            completion(users)
        }
    }
}
