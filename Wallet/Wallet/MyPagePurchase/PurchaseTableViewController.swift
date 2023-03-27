//
//  PurchaseTableViewController.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/25.
//

import UIKit
import Firebase
import FirebaseStorage

class PurchaseTableViewController: UITableViewController , UIImagePickerControllerDelegate {

    
    
    @IBOutlet var PurchaseViewList: UITableView!
    
    
    let user = Auth.auth().currentUser
    var purchaseStore: [PurchaseDBModel] = []
    
    let purchasequeryModel = PurchaseQueryModel()
    
    let picker = UIImagePickerController()
    var downURL: String = ""
    
    var Pemail = ""
    var email = ""
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email = defaults.string(forKey: "email")!
        Pemail = email
//        purchasequeryModel.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        reloadAction()
//        PurchaseTableViewController.reloadData()
    }
    
    func reloadAction(){
        
        
        purchasequeryModel.downloadItems(email: user!.email!)
//        PurchaseViewList.reloadData()
        print("*******")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return purchaseStore.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell", for: indexPath) as! PurchaseTableViewCell
        print("PurchaseTableViewController")
//        cell.test(email: user.email!)

        // Configure the cell...
        cell.lblTitle.text = purchaseStore[indexPath.row].pTitle
        cell.lblPrice.text = purchaseStore[indexPath.row].pPrice

        let storage = Storage.storage()
        let httpsReference = storage.reference(forURL: purchaseStore[indexPath.row].imageURL)

        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
              print("Error : \(error)")
          } else {
              cell.imgView.image = UIImage(data: data!)
          }
        }

        return cell
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

}
extension PurchaseTableViewController: PurchaseQueryModelProtocol{
    func itemDownloaded(items: [PurchaseDBModel]) {
        purchaseStore = items
        print("extensionpurchase")
        print(items)
        
        self.PurchaseViewList.reloadData()
    }
}
