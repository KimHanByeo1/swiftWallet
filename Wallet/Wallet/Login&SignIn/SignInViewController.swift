//
//  SignInViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/19.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class SignInViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailStatusBar: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var passwordStatusBar: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var lblSignupButton: UIButton!
    
    let passwordCheckDelay = 0.01 // 비밀번호 확인 대기 시간 (초)
        
    var passwordTimer: Timer? // 비밀번호 확인 타이머
    
    // Firebase Database(Real-time 연결)
    var firebaseDB: DatabaseReference!
    
    // firebase auth
    let authViewModel = AuthViewModel()
    
    // firebase cloud(닉네임 및 전화번호)
    let dbViewModel = DBViewModel()
    
    //정규식
    let userModel = RegExModel()
    
    var verificationID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UITextFieldDelegate 설정
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
                
        // 초기 statusBar 설정
        passwordStatusBar.text = "비밀번호를 입력하세요"
        lblSignupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    
    @objc private func signupButtonTapped(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let nickname = nicknameTextField.text else{return}
        
        // Firebase Login
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            guard let result = authResult, error == nil else{
                print("Error creating user")
                return
            }
            
            let user =  result.user
            print("Created User: \(user)")
        })
    }
    
    // UITextFieldDelegate 메서드
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let password = passwordTextField.text, let _ = passwordConfirmTextField.text else {
                return true
            }
            
//            let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
//            let isEqual = password == confirmPassword
            
            if textField == passwordConfirmTextField {
                // 이전에 실행되던 타이머가 있다면, 취소
                passwordTimer?.invalidate()
                
                // 대기 시간 후 비밀번호 확인 실행
                passwordTimer = Timer.scheduledTimer(withTimeInterval: passwordCheckDelay, repeats: false) { [weak self] _ in
                    if self!.passwordTextField.text != self!.passwordConfirmTextField.text {
                        self?.passwordStatusBar.text = "비밀번호가 일치하지 않습니다"
                    } else {
                        self?.passwordStatusBar.text = "비밀번호가 일치합니다"
                    }
                }
            } else if userModel.isValidPassword(pwd: password) {
                passwordStatusBar.text = "6자리 이상 입력해 주세요"
            } else {
                passwordStatusBar.text = "비밀번호를 입력하세요"
            }
            
            return true
        }
                    
    
 
    @IBAction func emailCheck(_ sender: UIButton) {
        
        let email = emailTextField.text!
        // Check if email is already in use
        if userModel.isValidEmail(id: email){
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
                
            }   // email check auth
        }else{
            emailStatusBar.text = "이메일 형식을 확인해주세요."
        }
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
            let resultAlert = UIAlertController(title: "빈칸 확인", message: "이메일을 확인해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네 알겠습니다.", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }else if nicknameTextField.text!.isEmpty{
            let resultAlert = UIAlertController(title: "빈칸 확인", message: "닉네임 확인해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네 알겠습니다.", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }else if passwordTextField.text!.isEmpty || passwordConfirmTextField.text!.isEmpty {
            let resultAlert = UIAlertController(title: "빈칸 확인", message: "비밀번호를 확인해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네 알겠습니다.", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }else{
            // Create new user account
            self.authViewModel.signIn(email: email, password: password) { user, error in
                if let user = user {
                    
                    self.dismiss(animated: true)
                    print("Sign In Success!")
                    self.dbViewModel.createUser(uid: user.user.uid, email: email, nickname: nickname)
                    
                    let resultAlert = UIAlertController(title: "알림", message: "회원가입 성공!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "네 알겠습니다.", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
                    
                    resultAlert.addAction(okAction)
                    self.present(resultAlert, animated: true)
                    
                    let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignInViewController
                    let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LogInViewController
                    
                    self.transition(from: vc1, to: vc2)
                } else {
                    
                    print("Sign In Failed. \(error.debugDescription)")
                    let resultAlert = UIAlertController(title: "에러", message: "회원가입에 실패했습니다.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "네 알겠습니다.", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
                    
                    resultAlert.addAction(okAction)
                    self.present(resultAlert, animated: true)
                    
                    
                }
            }
            }
        
        firebaseDB = Database.database().reference()
        firebaseDB.child("users").setValue(["email":emailTextField.text!.trimmingCharacters(in: .whitespaces) , "name": nicknameTextField.text!.trimmingCharacters(in: .whitespaces)])
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
        
        
    
    // telVerifyVeiwController에서 SignupViewController로 직접 전환하는 함수
    func transition(from fromViewController: UIViewController, to toViewController: UIViewController) {

        let fromVC = self // 현재 View Controller
        let toVC = storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LogInViewController // 전환할 View Controller

        fromVC.addChild(toVC)
        fromVC.view.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.bounds
        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toVC.didMove(toParent: fromVC)
    }
        
    
}
