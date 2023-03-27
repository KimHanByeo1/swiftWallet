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
    // like collection imageURL과 같은 product만 가져옴
    var likeProduct: [LikeProductModel] = []
    
    
    let uid = Auth.auth().currentUser!.uid
    
    // controller 연결
    let likecodeDB = LikeCodeDB()
    let productModel = LikeCodeDB()
    let updateModel = LikeCodeDB()

    //like
    var imageCode = ""
    var like: [String] = []
    var indexNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        likecodeDB.delegate = self
        productModel.delegate = self
        
        
    }

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {

        // like의 imageURL code 가져오기
        productModel.downloadItems(uid: uid)
        
        productModel.downloadLikes(uid: uid)
   
    }
    
   
    
    
    
    @IBAction func likeButton(_ sender: UIButton) {
        
        let cells = MyPageLikeTableViewCell()
//        cells.updateLike(uid: uid, imageCode: likeCode[indexNum], like: like[indexNum])
    }
    
    
//    func updateLike(){
//
//        updateModel.updateItems(uid: uid, imageCode: imageCode, like: like)
//    //해당 셀 인덱스 번호 > 번호 내용 > 내용 중 docId..
//
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
        
        
        cell.btnLikeText.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cell.btnLikeText.tag = indexPath.row // 버튼의 tag에 indexPath.row를 저장합니다.
        print(cell.btnLikeText.tag)


        return cell
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
      let index = sender.tag // 눌린 버튼의 인덱스 번호를 가져옵니다.
      print(index)
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MyPageLikeTableViewCell
        

        if like[index] == "1" {
            like[index] = "0"
            cell.btnLikeText.setImage(UIImage(named: "like1"), for: .normal)
            updateModel.updateItems(uid: uid, imageCode: likeCode[index], like: like[index])

        } else{
            like[index] = "1"
            cell.btnLikeText.setImage(UIImage(named: "like2"), for: .normal)

            updateModel.updateItems(uid: uid, imageCode: likeCode[index], like: like[index])
        }
        

        print(likeCode[index] ?? "없어")
        print(like[index] ?? "shsh")
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
    
    
    
}



extension MyPageLikeTableViewController: LikeCodeDBProtocol{
    func itemDownloaded(items: [String]) {
        likeCode = items
        self.tvTable.reloadData()
        likecodeDB.bringProducts(code: likeCode)
    }
    func itemLike(itemss: [String]) {
        like = itemss
        print(like)
        self.tvTable.reloadData()
    }
    func itemBring(products: [LikeProductModel]) {
        likeProduct = products
        self.tvTable.reloadData()
    }

}
