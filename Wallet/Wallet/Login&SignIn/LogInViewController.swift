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
    
    let authViewModel = AuthViewModel()
    let regExModel = RegExModel()
    let dbModel = DBViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        let email = emailField.text!
        let password = passwordField.text!
        

        
        if regExModel.isValidEmail(id: email) {
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        }else {
            shakeTextField(textField: emailField)
            let emailLabel = UILabel(frame: CGRect(x: 68, y: 350, width: 279, height: 45))
            emailLabel.text = "이메일을 확인해 주세요"
            emailLabel.textColor = UIColor.red
            emailLabel.tag = 100
            
            // 잘못 입력하면 텍스트 비워줌
            emailField.text = ""
            
            self.view.addSubview(emailLabel)
            
        } // 이메일 입력오류
        
        
        if regExModel.isValidPassword(pwd: password){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        }
        else{
            shakeTextField(textField: passwordField)
            let passwordLabel = UILabel(frame: CGRect(x: 68, y: 435, width: 279, height: 45))
            passwordLabel.text = "비밀번호을 확인해 주세요"
            passwordLabel.textColor = UIColor.red
            passwordLabel.tag = 101
            
            //잘못입력하면 텍스트 비워줌
            passwordField.text = ""
            
            self.view.addSubview(passwordLabel)
        } // 비밀번호 입력 오류
        
        
        if regExModel.isValidEmail(id: email) && regExModel.isValidPassword(pwd: password) {
            authViewModel.logIn(email: email, password: password) { [self] (success) in
                if success {
                    // Handle successful login
                    print("로그인 성공")
                    print(email)
                    let uid = Auth.auth().currentUser?.uid ?? ""
                    
                        Firestore.firestore().collection("users").document(uid).getDocument { [self] (snapshot, error) in
                            if let data = snapshot?.data() {
                                let nickname = data["nickname"] as? String ?? ""
                                let phone = data["phone"] as? String ?? ""
                                
                                
                                
                                
                                
                                //UserDefaults를 위한 세팅(alike sharedPreferences)
                                dbModel.saveUserInfo(email: email, nickname: nickname, phone: phone)
                                
                                
                                
                                
                                
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
                    let loginFailLabel = UILabel(frame: CGRect(x: 68, y: 610, width: 279, height: 45))
                    loginFailLabel.text = "아이디나 비밀번호가 다릅니다."
                    loginFailLabel.textColor = UIColor.red
                    loginFailLabel.tag = 102
                    
                    self.view.addSubview(loginFailLabel)
                }
            }
            
            
            

        }
        
    }
    
    
    
    @IBAction func SinginButton(_ sender: UIButton) {
        
        
        
//        if let viewController = storyboard?.instantiateViewController(withIdentifier: "TelVerifyViewController") {
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
        
        
        
        let signupFirstStoryboard = UIStoryboard(name: Const.Storyboard.Name.signUpFirst, bundle: nil)

                guard let TelVerifyViewController = signupFirstStoryboard.instantiateViewController(withIdentifier: Const.ViewController.identifier.signUpFirst) as? TelVerifyViewController else { return }

                self.navigationController?.pushViewController(TelVerifyViewController, animated: true)
            
        
        
            
        
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


}

extension Const {

    struct ViewController {

        struct identifier {
            static let signUpFirst = "TelVerifyViewController"
        }
    }
}
