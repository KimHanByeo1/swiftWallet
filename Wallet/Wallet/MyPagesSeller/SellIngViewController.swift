//
//  SellIngViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/24.
//

import UIKit
import Firebase
import FirebaseStorage


class SellIngViewController: UITableViewController {
    
    

    
    @IBOutlet var tvView: UITableView!
    
    
    // userNick이 같은 product만 가져옴
    var mySellingProduct: [MySellProductModel] = []
    
    
    let uid = Auth.auth().currentUser!.uid
    
    // controller 연결
    let mySellingDB = MySellDB()

    
    // 유저의 이메일
    
    var userEmail = Auth.auth().currentUser!.email
    
    // 상품 판매중
    let sellingState = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mySellingDB.delegate = self
        print("viewdid")
        
    }

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {

        
        // like의 imageURL code 가져오기
        mySellingDB.sellingData(userEmail: userEmail!, pState: sellingState)
        
        
        
        print("viewwill")
   
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(mySellingProduct.count)
        return mySellingProduct.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sellingCell", for: indexPath) as! SellIngViewCell

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let dateViewModel = DateViewModel()
        
        // url 비동기 통신
        if let imageURL = URL(string: mySellingProduct[indexPath.row].imageURL) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.sellingImage.image = image
                    }
                }
            }.resume()
        }
        
        
//        cell.sellingImage.image = UIImage(named: "shop")
        cell.sellingName.text = mySellingProduct[indexPath.row].pTitle
        
        cell.sellingBrand.text = mySellingProduct[indexPath.row].pBrand + " · " + dateViewModel.DateCount(mySellingProduct[indexPath.row].pTime)
        cell.sellingPrice.text = numberFormatter.string(from: NSNumber(value: Int(mySellingProduct[indexPath.row].pPrice)!))! + " 원"
        
        var sellingStatus: String = "판매중"

        if mySellingProduct[indexPath.row].pState == "0" {
            sellingStatus = "판매중"
            cell.sellingStatus.textColor = UIColor.green
        } else {
            sellingStatus = "판매완료"
            cell.sellingStatus.textColor = UIColor.red
        }

        cell.sellingStatus.text = sellingStatus
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SgSelling"{
                let cell = sender as! UITableViewCell
                let indexPath = self.tvView.indexPath(for: cell)
                let detailView = segue.destination as! DetailViewController
                
                detailView.imageURL = mySellingProduct[indexPath!.row].imageURL
            }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // 각 셀의 높이
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }

}


extension SellIngViewController: MySellDBProtocol{
   
    func itemBring(products: [MySellProductModel]) {
        mySellingProduct = products
        
        self.tvView.reloadData()
    }
    

}
