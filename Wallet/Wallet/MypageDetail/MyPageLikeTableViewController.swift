//
//  MyPageLikeTableViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/22.
//

import UIKit
import Firebase
import FirebaseStorage

class MyPageLikeTableViewController: UITableViewController, UserModelProtocal, SelectDocIdModelProtocal {

    
    @IBOutlet var tvTable: UITableView!
    
    //like collection의 code 담는 곳
    var likeCode: [String] = []
    // like collection imageURL과 같은 product만 가져옴
    var likeProduct: [LikeProductModel] = []
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "myLikeCell", for: indexPath) as! MyPageLikeTableViewCell
    
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let dateViewModel = DateViewModel()
        
        
        // Configure the cell...
        cell.pPrice.text = numberFormatter.string(from: NSNumber(value: Int(likeProduct[indexPath.row].pPrice)!))! + " 원"
        cell.pTitle.text = likeProduct[indexPath.row].pTitle
        cell.pBrand.text = likeProduct[indexPath.row].pBrand + " · " + dateViewModel.DateCount(likeProduct[indexPath.row].pTime)

        
        // url 비동기 통신
        if let imageURL = URL(string: likeProduct[indexPath.row].imageURL) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.pImage.image = image
                    }
                }
            }.resume()
        }
        
        var lblStateText: String = "판매중"

        if likeProduct[indexPath.row].pState == "0" {
            lblStateText = "판매중"
            cell.lblState.textColor = UIColor.green
        } else {
            lblStateText = "판매완료"
            cell.lblState.textColor = UIColor.red
        }

        cell.lblState.text = lblStateText
        
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(clikeButtonTapped(sender:)), for: .touchUpInside)
        
//        if like == "0" ?? cell.likeButton.setImage(UIImage(named: "like1"), for: .normal) : cell.likeButton.setImage(UIImage(named: "like2"), for: .normal)

//        if like == "0" {
//            print("0's")
//            print(like)
//            cell.likeButton.setImage(UIImage(named: "like2"), for: .normal)
//            like = "1"
//            // Insert (나 찜 했다!)
//            likeVM.insesrtItems(
//                    uid: uid,
//                    code: imageURL,
//                    like: like)
//
//        } else {
//            print("1's")
//            print(like)
//            cell.likeButton.setImage(UIImage(named: "like1"), for: .normal)
//            like = "0"
//            // 삭제를 위한 Like 컬렉션의 문서ID 가져오는 쿼리
//            let likeViewModel = LikeViewModel()
//            likeViewModel.delegate = self
//            likeViewModel.SelectDocId(imageURL: imageURL, uid: uid)
//        }

        return cell
    }
    
    @objc func clikeButtonTapped(sender: UIButton) {
        print("\(sender.tag) 버튼의 Tag로 index값을 받아서 데이터 처리")
        if (like == "0") { // no찜 -> yes찜
            likeButton.setImage(UIImage(named: "clicklike"), for: .normal)
            like = "1"

            // Insert (나 찜 했다!)
            likeVM.insesrtItems(
                    uid: uid,
                    code: imageURL,
                    like: like)

        } else { // yes찜 -> no찜
            likeButton.setImage(UIImage(named: "unclicklikc"), for: .normal)
            
            like = "0"

            // 삭제를 위한 Like 컬렉션의 문서ID 가져오는 쿼리
            let likeViewModel = LikeViewModel()
            likeViewModel.delegate = self
            likeViewModel.SelectDocId(imageURL: imageURL, uid: uid)

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
        return 156
    }
    
    
    //-------찜like-----------
    // userModel.downloadUser
    func userItemDownLoaded(items: [UserLikeModel]) {
        
        userLikeModel = items
        
        like = userLikeModel.first?.like ?? "0"
        
        if (like == "1") { // 1 이면 yes찜
            likeButton.setImage(UIImage(named: "clicklike"), for: .normal)
        } else { // 0 이면 no찜
            likeButton.setImage(UIImage(named: "unclicklike"), for: .normal)
            
        }
        
    }
    
    func SelectDocId(items: [LikeModel]) {
        likeModel = items
        
        // 문서ID로 삭제하는 쿼리
        likeVM.DeleteItems(
            // likeModel.first?.docId ?? "" << 가져온 문서ID
            docId: likeModel.first?.docId ?? "",
            uid: uid)
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
