//
//  TabBarViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/19.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    
    // 사용자 정보 sharedpreference
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let email = defaults.string(forKey: "email")
        let nickname = defaults.string(forKey: "nickname")
        let profileImage = defaults.string(forKey: "profileImage")
        
        
        
        // 이런식으로 사용하면 됩니당(어디다 넣어야 될지 몰라서 일단 tabbarcontroller 만들어서 넣어놨어요)
        
        
        //emailCheck.text = nickname
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
