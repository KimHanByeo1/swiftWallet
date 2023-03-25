//
//  TabManViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/23.
//

import UIKit
import Tabman
import Pageboy

class TabManViewController: TabmanViewController {

    
    @IBOutlet weak var tabView: UIView!
    
        
    private var viewControllers: [UITableViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupTabMan()
        
    }
    
    
    
    private func setupTabMan() {
        let firstVC = storyboard?.instantiateViewController (withIdentifier:
        "sellingViewcontroller") as! SellIngViewController
        let secondVC = storyboard?.instantiateViewController (withIdentifier:
        "sellFinViewController") as! SellFinViewController
                
        viewControllers.append (firstVC)
        viewControllers.append (secondVC)
        
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        
        //배경회색으로나옴->하얀색으로바뀜
        bar.backgroundView.style = .blur(style: .light)
        //간격설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        //버튼글씨커스텀
        bar.buttons.customize { (button) in
        button.tintColor = .systemGray4
            button.selectedTintColor = .black
            button.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            button.selectedFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        //밑줄쳐지는부분
        bar.indicator.weight = .custom (value: 2)
        bar.indicator.tintColor = .black
        addBar(bar, dataSource: self, at: .top)
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

extension TabManViewController: PageboyViewControllerDataSource, TMBarDataSource {

    
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title:"판매중")
        case 1:
            return TMBarItem(title:"판매완료")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
            }
        }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}


