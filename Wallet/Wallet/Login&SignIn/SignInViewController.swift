//
//  SignInViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/19.
//

import UIKit
import FirebaseAuth



class SignInViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailStatusBar: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var passwordStatusBar: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var allStatusBar: UILabel!
    
    
    
    
    
    // firebase auth
    let authViewModel = AuthViewModel()
    
    // firebase cloud(닉네임 및 전화번호)
    let dbViewModel = DBViewModel()
    
    //정규식
    let userModel = RegExModel()
    
    var verificationID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
 
    @IBAction func emailCheck(_ sender: UIButton) {
        
        let email = emailTextField.text!
        // Check if email is already in use
        Auth.auth().fetchSignInMethods(forEmail: email) { [weak self] methods, error in
            guard let self = self else { return }
            if let error = error {
                self.emailStatusBar.text = "오류가 발생했습니다."
                print("Failed to fetch sign-in methods: \(error.localizedDescription)")
                return
            }
            
            if let methods = methods, !methods.isEmpty {
                self.emailStatusBar.text = "중복된 이메일입니다."
                self.shakeTextField(textField: self.emailTextField)
                self.emailTextField.text = ""
            }else{
                self.emailStatusBar.text = "사용할 수 있는 이메일입니다."
            }
            
        }// email check auth
    }
    
    
    
    // 인증 재요청
    
    // 키보드에 번호 바로 올라가기
    
    // 약관 동의해야 회원가입 가능하게!!
    

    @IBAction func signInButtonClicked(_ sender: UIButton) {
        signinCheck()
        
    }
    
    
    // TextField 흔들기 애니메이션
        func shakeTextField(textField: UITextField) -> Void{
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x -= 10
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x += 20
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        textField.frame.origin.x -= 10
                    })
                })
            })
        }
        
        // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
        @objc func didEndOnExit(_ sender: UITextField) {
            if nicknameTextField.isFirstResponder {
                emailTextField.becomeFirstResponder()
            }
            else if emailTextField.isFirstResponder {
                passwordTextField.becomeFirstResponder()
            }
            else if passwordTextField.isFirstResponder {
                passwordConfirmTextField.becomeFirstResponder()
            }
        }
    
    //화면 아무곳이나 누르면 키보드 내려가기
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        @objc func keyboardWillAppear(_ sender: NotificationCenter){
            self.view.frame.origin.y = -150
        }
        
        @objc func keyboardWillDisAppear(_ sender: NotificationCenter){
            self.view.frame.origin.y = 0.0
        }
    
    
    func signinCheck() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let passwordCheck = passwordConfirmTextField.text!
       
        let nickname = nicknameTextField.text!
        
        
        if emailTextField.text!.isEmpty {
            self.allStatusBar.text = "이메일은 입력해 주세요"
        }else {
            
        }
        
        
        
      
//            if let methods = methods, !methods.isEmpty {
//                self.statusBar.text = "중복된 이메일입니다."
//                self.shakeTextField(textField: self.emailTextField)
//                self.emailTextField.text = ""
//            }else{
//                // Create new user account
//                self.authViewModel.signIn(email: email, password: password) { user, error in
//                    if let user = user {
//                        self.statusBar.text = "회원가입 성공!"
//                        self.dismiss(animated: true)
//                        print("Sign In Success!")
//                        self.dbViewModel.createUser(uid: user.user.uid, email: email, nickname: nickname)
//                    } else {
//                        self.statusBar.text = "오류가 발생했습니다."
//                        print("Sign In Failed. \(error.debugDescription)")
//                    }
//                }
//            }
//
//        }// email check auth
        
        
    }

        
    
}
