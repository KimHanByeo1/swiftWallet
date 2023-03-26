//
//  LogoutDoneViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/25.
//

import UIKit

class LogoutDoneViewController: UIViewController {

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true;
        self.tabBarController?.tabBar.isHidden = true;
        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func loginBtn(_ sender: UIButton) {
        
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "LogoutDone") as! LogoutDoneViewController
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "firstController") as! FirstViewController
        self.transition1(from: vc1, to: vc2)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // logout후 로그인 페이지로 전환하는 함수
    func transition1(from fromViewController: UIViewController, to toViewController: UIViewController) {
        
        let fromVC = self // 현재 View Controller
        let toVC = storyboard?.instantiateViewController(withIdentifier: "firstController") as! FirstViewController // 전환할 View Controller
        
        fromVC.addChild(toVC)
        fromVC.view.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.bounds
        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toVC.didMove(toParent: fromVC)
    }
    
}
