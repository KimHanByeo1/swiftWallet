//
//  CustomSideMenuNavigation.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/21.
//

import UIKit
import SideMenu

class CustomSideMenuNavigation: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentationStyle = .menuSlideIn
        self.menuWidth = self.view.frame.width * 0.6
        self.statusBarEndAlpha = 0.0
        //보여지는 속도
        self.presentDuration = 1.0
        //사라지는 속도
        self.dismissDuration = 1.0
        
        self.presentationStyle.backgroundColor = .black
        self.presentationStyle.presentingEndAlpha = 0.2

    }
    
}
