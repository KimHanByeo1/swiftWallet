//
//  PurchaseTableViewController.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/24.
//

import UIKit
import Firebase
import FirebaseStorage

class PurchaseTableViewController: UITableViewController, UserModelProtocal, LikeCodeDBProtocol {
    func itemDownloaded(items: [String]) {
        <#code#>
    }
    
    func itemBring(products: [LikeProductModel]) {
        <#code#>
    }
    
    func userItemDownLoaded(items: [UserLikeModel]) {
        <#code#>
    }
    

    @IBOutlet var purchaseList: UITableView!
    
    //like collection의 code 담는 곳
    var likeCode: [String] = []
    // like collection imageURL과 같은 product만 가져옴
    var likeProduct: [PurchaseProductModel] = []
    
    
    let uid = Auth.auth().currentUser!.uid
    
    // controller 연결
    let likecodeDB = LikeCodeDB()
    let productModel = LikeCodeDB()
    
    // --------찜like------------
    let userModel = UserLikeData()
    
    var imageURL = "" // MainController에서 넘겨준 imageURL 값 받는 변수
    var like = "" // 찜 여부 확인 0,1
    
    var userLikeModel: [UserLikeModel] = []
    var likeModel: [LikeModel] = []
    
    let likeVM = LikeViewModel() // 여러개의 function에서 사용하기위해 전역변수로 생성
    var buttonImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        userModel.delegate = self
        likecodeDB.delegate = self
        productModel.delegate = self
        
        userModel.downloadUser(imageURL: imageURL, uid: uid) // 유저가 선택한 상품의 찜 여부 확인을 위한 Select
    }

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {

        // like의 imageURL code 가져오기
        productModel.downloadItems(uid: uid)
   
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return likeProduct.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PruchaseCell", for: indexPath) as! PurchaseTableViewCell
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let dateViewModel = DateViewModel()

        // Configure the cell...

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
