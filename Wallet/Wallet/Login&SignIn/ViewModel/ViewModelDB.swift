//
//  DBViewModel.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/19.
//

import FirebaseFirestore

class ViewModelDB : NSObject {
    

    
    let db = Firestore.firestore()
    
    func createUser(uid:String, email:String, nickname:String){
        db.collection("users").document(uid).setData(["email": email, "nickname": nickname]){
            err in
            if let err = err {
                print("Error Occured from addDocument : \(err)")
            }
            else{
                print("Adding Document is Success!")
            }
        }
    }
    
    //로그인한 해당 유저의 닉네임 불러오기
        func fetchNickname(forEmail email: String, completion: @escaping (String?) -> Void) {
                Firestore.firestore().collection("users").document(email).getDocument { (snapshot, error) in
                    if let data = snapshot?.data(), let nickname = data["nickname"] as? String {
                        completion(nickname)
                    } else {
                        completion(nil)
                    }
                }
            }
    
    
    // 로그인한 유저 정보 가지고 오기(sharedpreference)
    func saveUserInfo(email: String, nickname: String, phone: String) {
        let defaults = UserDefaults.standard
        
        defaults.set(email, forKey: "email")
        defaults.set(nickname, forKey: "nickname")
        defaults.set(phone, forKey: "phone")
    }
   
}

