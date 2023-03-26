//
//  LogInViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/19.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var lblLoginButton: UIButton!
    
    
    @IBOutlet weak var emailCheck: UILabel!
    @IBOutlet weak var passwordCheck: UILabel!
    
    //자동 로그인 switch
    @IBOutlet weak var autoLogin: UISwitch!
    
    
    
    let authViewModel = AuthViewModel()
    let regExModel = RegExModel()
    let dbModel = DBViewModel()
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //lblLoginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        

//
        // 자동 로그인 기능 추가
            if let email = defaults.string(forKey: "email"), let password = defaults.string(forKey: "password") {
                login(email: email, password: password)
            }
        
        
        
        autoLogin.isOn = false
        
    }
    
    
    private func login(email: String, password: String) {
        authViewModel.logIn(email: email, password: password) { [self] (success) in
            if success {
                // Handle successful login
                print("로그인 성공")
                print(email)
                let uid = Auth.auth().currentUser?.uid ?? ""
                
                    Firestore.firestore().collection("users").document(uid).getDocument { [self] (snapshot, error) in
                        if let data = snapshot?.data() {
                            let nickname = data["nickname"] as? String ?? ""
                            let profileImage = data["profileImage"] as? String ?? ""
                            
                            
                            
                            
                            if profileImage.isEmpty{
                                //UserDefaults를 위한 세팅(alike sharedPreferences)
                                dbModel.saveUserInfo(email: email, nickname: nickname, profileImage: nil)
                            }else{
                                dbModel.saveUserInfo(email: email, nickname: nickname, profileImage: profileImage)
                            }
   
                            
                        } else {
                            // Handle error
                            print("Error getting user document: \(error?.localizedDescription ?? "")")
                        }
                    }
                
                
            } else {
                // Handle failed login
                print("로그인 실패")
                shakeTextField(textField: emailField)
                shakeTextField(textField: passwordField)
                //let loginFailLabel = UILabel(frame: CGRect(x: 68, y: 610, width: 279, height: 45))
                passwordCheck.text = "아이디나 비밀번호가 다릅니다."
//                passwordCheck.textColor = UIColor.red
//                passwordCheck.tag = 102
                
                //self.view.addSubview(loginFailLabel)
            }
        }
    }
    
//    @objc private func loginButtonTapped(){
//        guard let email = emailField.text, let password = passwordField.text else{return}
//
//        // Firebase Login
//        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult, error in
//            guard let strongSelf = self else{
//                return
//            }
//            guard let result = authResult, error == nil else{
//                print("Failed to login user with email : \(email)")
//                return
//            }
//
//            let user = result.user
//            print("Logged in User : \(user)")
//        })
//    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        let email = emailField.text!
        let password = passwordField.text!
        

        
        if regExModel.isValidEmail(id: email) {
//            if let removable = self.view.viewWithTag(100) {
//                removable.removeFromSuperview()
//            }
            emailCheck.text = ""
        }else {
            shakeTextField(textField: emailField)
            
            emailCheck.text = "이메일을 확인해 주세요"
            
            // 잘못 입력하면 텍스트 비워줌
            emailField.text = ""
            
           
            
        } // 이메일 입력오류
        
        
        if regExModel.isValidPassword(pwd: password){
//            if let removable = self.view.viewWithTag(101) {
//                removable.removeFromSuperview()
//            }
            passwordCheck.text = ""
            passwordCheck.text = ""
        }
        else{
            shakeTextField(textField: passwordField)
            passwordCheck.text = "비밀번호을 확인해 주세요"
            
            
            //잘못입력하면 텍스트 비워줌
            passwordField.text = ""
            
            
        } // 비밀번호 입력 오류
        
        
        if regExModel.isValidEmail(id: email) && regExModel.isValidPassword(pwd: password) {
            authViewModel.logIn(email: email, password: password) { [self] (success) in
                if success {
                    // Handle successful login
                    print("로그인 성공")
                    passwordCheck.text = ""
                    let uid = Auth.auth().currentUser?.uid ?? ""
                    
                        Firestore.firestore().collection("users").document(uid).getDocument { [self] (snapshot, error) in
                            if let data = snapshot?.data() {
                                let nickname = data["nickname"] as? String ?? ""
                                let profileImage = data["profileImage"] as? String ?? ""
                 
                                if profileImage.isEmpty{
                                    // 프로필 이미지 없을 때
                                    dbModel.saveUserInfo(email: email, nickname: nickname, profileImage: nil)
                                }else{
                                    // 프로필 이미지 있을 때
                                    dbModel.saveUserInfo(email: email, nickname: nickname, profileImage: profileImage)
                                }
                                
                                // 자동로그인 static 저장
                                if autoLogin.isOn == true {
                                    let dataSave = UserDefaults.standard
                                    dataSave.setValue(email, forKey: "email")
                                    dataSave.setValue(password, forKey: "password")
                                    UserDefaults.standard.synchronize()
                                }

                                
                                // 예시 - login 화면 tabBar화면들로 전환
                                let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LogInViewController
                                let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarViewController
                                self.transition(from: vc1, to: vc2)
                                
                                print(nickname)
                                
                            } else {
                                // Handle error
                                print("Error getting user document: \(error?.localizedDescription ?? "")")
                            }
                        }
                    
                    
                } else {
                    // Handle failed login
                    print("로그인 실패")
                    shakeTextField(textField: emailField)
                    shakeTextField(textField: passwordField)
                    
                    passwordCheck.text = "아이디나 비밀번호가 다릅니다."
                    //passwordCheck.textColor = UIColor.red
                    
                }
            }
            
            
            

        }
        
    }
    
    
    
    @IBAction func SinginButton(_ sender: UIButton) {
        
     
        guard let navigationController = navigationController else {
                print("navigationController is nil")
                return
            }
            
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignInViewController
        navigationController.pushViewController(vc, animated: true)
        

    }
    
    // 자동로그인 스위치
    @IBAction func autoLoginSwitchValueChanged(_ sender: UISwitch) {
        
        print(autoLogin.isOn)
        UserDefaults.standard.set(sender.isOn, forKey: "autoLogin")
            UserDefaults.standard.synchronize()
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
        if emailField.isFirstResponder {
            passwordField.becomeFirstResponder()
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
    
    
    
    // login에서 tabbar로 직접 전환하는 함수
    func transition(from fromViewController: UIViewController, to toViewController: UIViewController) {
        
        let fromVC = self // 현재 View Controller
        let toVC = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController // 전환할 View Controller

        fromVC.addChild(toVC)
        fromVC.view.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.bounds
        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toVC.didMove(toParent: fromVC)
    }
    
    
    
    // login에서 회원가입으로 직접 전환하는 함수
    func transition2(from fromViewController: UIViewController, to toViewController: UIViewController) {
        
        let fromVC = self // 현재 View Controller
        let toVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignInViewController // 전환할 View Controller

        fromVC.addChild(toVC)
        fromVC.view.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.bounds
        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toVC.didMove(toParent: fromVC)
    }



}


