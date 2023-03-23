//
//  SideMenuViewController.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/21.
//

import UIKit

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var sidemenuTV: UITableView!
    let brandName: [String] = ["전체 (ALL)", "구찌 (GUCCI)", "루이비통 (Louis Vuitton)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sidemenuTV.delegate = self
        sidemenuTV.dataSource = self
    }
    
    func postBrandNotification(brandName: String) {
        NotificationCenter.default.post(name: NSNotification.Name("BrandDidSelect"), object: self, userInfo: ["brandName": brandName])
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideCell", for: indexPath) as! SideMenuTableViewCell
        
        cell.lblBrand.text = brandName[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let brandName = self.brandName[indexPath.row]
        postBrandNotification(brandName: brandName)
        dismiss(animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
    
}
