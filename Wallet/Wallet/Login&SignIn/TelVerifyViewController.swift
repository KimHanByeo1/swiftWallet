//
//  TelVerifyViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/19.
//

import UIKit
import Firebase

class TelVerifyViewController: UIViewController {

    
    @IBOutlet weak var phoneNumberTextField: UITextField!

    @IBOutlet weak var verificationNumber: UITextField!
    
    
    let userModel = RegExModel()
    var verificationID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func verifyPhoneNumber(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        
        
        if userModel.isValidPhone(phone: phoneNumber) || phoneNumberTextField.text!.isEmpty {
                    let alert = UIAlertController(title: "전화번호 확인", message: "유효하지 않은 전화번호입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return
                }

        
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+82\(phoneNumber)", uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("Failed to request verification code: \(error.localizedDescription)")
                let alert = UIAlertController(title: "전화번호 인증", message: "검증 코드 요청에 실패했습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if let verificationID = verificationID {
                UserDefaults.standard.set(verificationID, forKey: "verificationID")
                print("Verification code sent: \(verificationID)")
                // Firebase에서 생성한 인증번호를 저장합니다.
                
            }
        

                }
        }
    
    
    @IBAction func verifyOk(_ sender: UIButton) {
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID"),
                  let sentCode = UserDefaults.standard.string(forKey: "sentCode"),
                  let verificationCode = verificationNumber.text
            else {
                return
            }
            
            print(verificationCode)
            print(verificationID)
            
            
        
            let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID,
                    verificationCode: verificationCode)
            
            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    print("Error signing in with phone credential: \(error.localizedDescription)")
                    
                    let resultAlert = UIAlertController(title: "에러 발생", message: "인증번호가 틀립니다", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "네 알겠습니다.", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
                    
                    resultAlert.addAction(okAction)
                    self.present(resultAlert, animated: true)
                } else {
                    print("Phone number verified successfully")
                    let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "TelVerifyViewController") as! TelVerifyViewController
                    let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignInViewController
                    
                    self.transition(from: vc1, to: vc2)
                }
            }
            
           
        
               
            
        
    }
    
    
    // telVerifyVeiwController에서 SignupViewController로 직접 전환하는 함수
    func transition(from fromViewController: UIViewController, to toViewController: UIViewController) {

        let fromVC = self // 현재 View Controller
        let toVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignInViewController // 전환할 View Controller

        fromVC.addChild(toVC)
        fromVC.view.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.bounds
        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toVC.didMove(toParent: fromVC)
    }

    func pass(credential: PhoneAuthCredential){
        
        
    }
    
    
}
