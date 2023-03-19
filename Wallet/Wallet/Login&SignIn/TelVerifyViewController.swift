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

                if userModel.isValidPhone(phone: phoneNumber) {
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
                    } else if let id = verificationID {
                        UserDefaults.standard.set("\(id)", forKey: "verificationID")
                        print("Verification code sent: \(id)")
                    }
                }
        }
    
    
    @IBAction func verifyOk(_ sender: UIButton) {
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID"), let verificationCode = verificationNumber.text else {
                    return
                }
        print(verificationCode)
        print(verificationID)
        
        let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID,
                    verificationCode: verificationCode
                    )
        
//        pass(credential: credential)
    }
    
    
    // telVerifyVeiwController에서 SignupViewController로 직접 전환하는 함수
//    func transition(from fromViewController: UIViewController, to toViewController: UIViewController) {
//
//        let fromVC = self // 현재 View Controller
//        let toVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignInViewController // 전환할 View Controller
//
//        fromVC.addChild(toVC)
//        fromVC.view.addSubview(toVC.view)
//        toVC.view.frame = fromVC.view.bounds
//        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        toVC.didMove(toParent: fromVC)
//    }
//
//    func pass(credential: PhoneAuthCredential){
//        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "TelVerifyViewController") as! TelVerifyViewController
//        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignInViewController
//        self.transition(from: vc1, to: vc2)
//    }
}
