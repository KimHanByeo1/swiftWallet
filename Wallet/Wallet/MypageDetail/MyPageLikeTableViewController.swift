//
//  MyPageLikeTableViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/22.
//

import UIKit
import Firebase
import FirebaseStorage

class MyPageLikeTableViewController: UITableViewController {

    
    @IBOutlet var tvTable: UITableView!
    
    //like collection의 code 담는 곳
    var likeCode: [String] = []
    var likeProduct: [LikeProductModel] = []
    
    
    

    
//    var codes: AnyObject?
    let uid = Auth.auth().currentUser!.uid
    
    
    let likecodeDB = LikeCodeDB()
    let productModel = LikeCodeDB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
     
       
       

        
        
        likecodeDB.delegate = self
        productModel.delegate = self
  
    }

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        
//        quertModel.delegate = self
        productModel.downloadItems(uid: uid)
        
//        likecodeDB.bringProducts(code: likeCode)
        
    }
    
//    func reloadAction(){
////        let queryModel = LikeCodeDB()
//
//        likecodeDB.delegate = self
//
//        likecodeDB.downloadItems(uid: uid)
//        likecodeDB.bringProducts(code: likeCode)
//        tvTable.reloadData()
//        print("reloadaction")
//        //print(queryModel)
//        print(likeCode)
//    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return likeProduct.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myLikeCell", for: indexPath) as! MyPageLikeTableViewCell

        // Configure the cell...
        cell.pPrice.text = likeProduct[indexPath.row].pPrice
        cell.pTitle.text = likeProduct[indexPath.row].pTitle
        cell.pBrand.text = likeProduct[indexPath.row].pBrand

        
        
        let storage = Storage.storage()
        let httpsReference = storage.reference(forURL: likeProduct[indexPath.row].imageURL)
                                               
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
              print("Error : \(error)")
          } else {
              cell.pImage.image = UIImage(data: data!)
          }
        }
        
        //cell.pImage.image = UIImage(named: "face")
        

        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }

}


extension MyPageLikeTableViewController: LikeCodeDBProtocol{
    func itemDownloaded(items: [String]) {
        likeCode = items
        self.tvTable.reloadData()
        likecodeDB.bringProducts(code: likeCode)
    }
    func itemBring(products: [LikeProductModel]) {
        likeProduct = products
        self.tvTable.reloadData()
    }
}

