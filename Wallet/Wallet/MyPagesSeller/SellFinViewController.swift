//
//  SellFinViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/24.
//

import UIKit
import Firebase
import FirebaseStorage


class SellFinViewController: UITableViewController {

    
    @IBOutlet var tvFinView: UITableView!
    
    
    // userNick이 같은 product만 가져옴
    var mySellingProduct: [MySellProductModel] = []
    
    
    let uid = Auth.auth().currentUser!.uid
    let userEmail = Auth.auth().currentUser!.email
    
    // controller 연결
    let mySellingDB = MySellDB()

    
    // 유저의 이메일
    
    
    // 상품 판매중
    let sellingState = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mySellingDB.delegate = self
        
    }

    // MARK: - Table view data source

    override func viewWillAppear(_ animated: Bool) {

        
//        userEmail = defaults.string(forKey: "email")!
        mySellingDB.sellingData(userEmail: userEmail!, pState: sellingState)
        
        
   
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return mySellingProduct.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sellFinCell", for: indexPath) as! SellFinViewCell

        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let dateViewModel = DateViewModel()
        
//         url 비동기 통신
        if let imageURL = URL(string: mySellingProduct[indexPath.row].imageURL) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.sellFinImage.image = image
                    }
                }
            }.resume()
        }
        
        cell.sellFinName.text = mySellingProduct[indexPath.row].pTitle
        cell.sellFinBrand.text = mySellingProduct[indexPath.row].pBrand + " · " + dateViewModel.DateCount(mySellingProduct[indexPath.row].pTime)
        cell.sellFinPrice.text = numberFormatter.string(from: NSNumber(value: Int(mySellingProduct[indexPath.row].pPrice)!))! + " 원"
        
        var sellingStatus: String = "판매완료"

        if mySellingProduct[indexPath.row].pState == "0" {
            sellingStatus = "판매중"
            cell.sellFinStatus.textColor = UIColor.green
        } else {
            sellingStatus = "판매완료"
            cell.sellFinStatus.textColor = UIColor.red
        }

        cell.sellFinStatus.text = sellingStatus
        //cell.sellingStatus.text = "판매중"
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SgSellFin"{
                let cell = sender as! UITableViewCell
                let indexPath = self.tvFinView.indexPath(for: cell)
                let detailView = segue.destination as! DetailViewController
                
                detailView.imageURL = mySellingProduct[indexPath!.row].imageURL
            }
    }
}

extension SellFinViewController: MySellDBProtocol{
   
    func itemBring(products: [MySellProductModel]) {
        mySellingProduct = products
        self.tvFinView.reloadData()
    }
    

}
