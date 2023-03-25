//
//  PayCompleteViewController.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/24.
//

import UIKit

class PayCompleteViewController: UIViewController {

    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    
    var balance: Int?
    var money: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.isHidden = true;
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let formattedMoney = formatter.string(from: NSNumber(value: money!)) {
            lblMoney.text = "\(formattedMoney) 원을 충전했어요"
        }
        if let formattedBalanceMoney = formatter.string(from: NSNumber(value: balance!)) {
            lblBalance.text = "   LuxPay 잔액: \(formattedBalanceMoney) 원"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    @IBAction func btnOk(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)?.navigationController?.popViewController(animated: false)
        let viewControllers : [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3 ], animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
