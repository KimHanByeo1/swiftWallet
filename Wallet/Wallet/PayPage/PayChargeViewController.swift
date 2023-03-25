//
//  PayChargeViewController.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/24.
//

import UIKit
import MaterialDesignWidgets
import Firebase

class PayChargeViewController: UIViewController, UITextFieldDelegate, PayChargeViewModelProtocol {
    
    @IBOutlet weak var tfMoney: UITextField!
    @IBOutlet weak var viewPay: UIView!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userNickname: UILabel!
    
    var payChargeDBModel: [PayChargeUserModel] = []
    let user = Auth.auth().currentUser
    var balance: Int?
    let formatter = NumberFormatter()
    let payChargeViewModel = PayChargeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tfMoney.delegate = self
        viewPay.layer.cornerRadius = viewPay.frame.height / 6
        userProfile.layer.cornerRadius = userProfile.frame.height / 2
        self.hideKeyboard()
        
        payChargeViewModel.delegate = self
        payChargeViewModel.downloadItems(email: user!.email!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    func itemDownloaded(items: [PayChargeUserModel]) {
        payChargeDBModel = items

        // url 비동기 통신
        if let imageURL = URL(string: items.first!.profileimage) {
            print(imageURL)
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.userProfile.image = image
                    }
                }
            }.resume()
        }
        userNickname.text = payChargeDBModel.first!.nickname
        balance = payChargeDBModel.first!.userBalance
        formatter.numberStyle = .decimal
        if let formattedMoney = formatter.string(from: NSNumber(value: balance!)) {
            lblBalance.text = "LuxPay 잔액: " + formattedMoney + " 원"
        }
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddPay(_ sender: UIButton) {
        let money = Int(tfMoney.text!.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " 원", with: "")) ?? 0
        if (money + balance!) != balance! {
            payChargeViewModel.addPay(email: user!.email!, userBalance: (money + balance!))
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PayCompleteViewController") as! PayCompleteViewController
            vc.money = money
            vc.balance = (money + balance!)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let resultAlert = UIAlertController(title: "알림", message: "충전 금액을 확인해주세요!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네 알겠습니다.", style: .default, handler: nil)
            resultAlert.addAction(okAction)
            self.present(resultAlert, animated: true)
        }
    }
    
    @IBAction func addPay(_ sender: UIButton) {
        var money = Int(tfMoney.text!.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " 원", with: "")) ?? 0
        
        switch (sender.titleLabel?.text)! {
        case "+1만원":
            money += 10000
        case "+5만원":
            money += 50000
        case "+10만원":
            money += 100000
        case "1":
            money = Int(String(money) + "1")!
        case "2":
            money = Int(String(money) + "2")!
        case "3":
            money = Int(String(money) + "3")!
        case "4":
            money = Int(String(money) + "4")!
        case "5":
            money = Int(String(money) + "5")!
        case "6":
            money = Int(String(money) + "6")!
        case "7":
            money = Int(String(money) + "7")!
        case "8":
            money = Int(String(money) + "8")!
        case "9":
            money = Int(String(money) + "9")!
        case "0":
            money = Int(String(money) + "0")!
        case "00":
            money = Int(String(money) + "00")!
        case "←":
            if String(money).count > 0 {
                money = Int(String(money).dropLast(1)) ?? 0
            }
        default: break
        }
        
        formatter.numberStyle = .decimal
        if let formattedMoney = formatter.string(from: NSNumber(value: money)) {
            tfMoney.text = "\(formattedMoney) 원"
        }
        if let formattedBalanceMoney = formatter.string(from: NSNumber(value: (balance! + money))) {
            lblBalance.text = " 충전 후 잔액: \(formattedBalanceMoney) 원"
        }

    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let formattedMoney = formatter.string(from: NSNumber(value: balance!)) {
            lblBalance.text = "LuxPay 잔액: \(formattedMoney) 원"
        }
        return true
    }

}




