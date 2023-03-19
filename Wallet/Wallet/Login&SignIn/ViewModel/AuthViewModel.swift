//
//  AuthViewModel.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/19.
//

import FirebaseAuth
import Firebase


class AuthViewModel : NSObject {
    
    var currentUser: String?
    var nickname: String?
    
    let dbModel = DBViewModel()
   
    
    func logIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if let user = user {
                self?.currentUser = user.description
                print("Log In Success!")

                
//                self?.dbModel.fetchNickname(forEmail: email) { [weak self] (nickname) in
//                    self?.nickname = nickname
                    completion(true)
//                }
            } else {
                print("Log In Failed. \(error.debugDescription)")
                completion(false) // Call the completion handler with a value of false
            }
        }
    }
    
    

    
    
    // auth로 회원가입
    func signIn(email:String, password:String, completeClousure:((AuthDataResult?, (any Error)?) -> Void)?){
            print("Try Signin: \(email), \(password)")
            Auth.auth().createUser(withEmail: email, password: password, completion: completeClousure)
        }
    
    
    // 전화번호 인증
    func verifyPhone(phone: String){
        PhoneAuthProvider.provider()
                        .verifyPhoneNumber("+82 \(phone)", uiDelegate: nil) { (verificationID, error) in
                    if let id = verificationID {
                        UserDefaults.standard.set("\(id)", forKey: "verificationID")
                    }
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
    }
    
    
   
    
}
