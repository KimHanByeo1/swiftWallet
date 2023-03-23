//
//  FirstViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/23.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.bool(forKey: "autoLogin") == true {
            // 자동 로그인 스위치가 켜져 있으면,
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "firstController") as! FirstViewController
            let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarViewController
            self.transition(from: vc1, to: vc2)
            print("pop")
            
            
        } else {
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "firstController") as! FirstViewController
            let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LogInViewController
            self.transition2(from: vc1, to: vc2)
            print("pop")
            
        }
        
        // Set the key window
       
    }
    
    
    
    // first에서 main로 직접 전환하는 함수(if자동로그인)
    func transition(from fromViewController: UIViewController, to toViewController: UITabBarController) {
        
        let fromVC = self // 현재 View Controller
        let toVC = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarViewController // 전환할 View Controller

        fromVC.addChild(toVC)
        fromVC.view.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.bounds
        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toVC.didMove(toParent: fromVC)
    }
    
    
    
    // first 에서 login 직접 전환하는 함수
    func transition2(from fromViewController: UIViewController, to toViewController: UIViewController) {
        
        let fromVC = self // 현재 View Controller
        let toVC = storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LogInViewController // 전환할 View Controller

        fromVC.addChild(toVC)
        fromVC.view.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.bounds
        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toVC.didMove(toParent: fromVC)
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
