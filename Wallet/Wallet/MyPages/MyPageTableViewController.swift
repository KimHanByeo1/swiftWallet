//
//  MyPageTableViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/21.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class MyPageTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    
    @IBOutlet var MyPageTableView: UITableView!
    
    
    let defaults = UserDefaults.standard
    var nickname = ""
    var email = ""
    var image = ""
    var imageFB:UIImage?

    let picker = UIImagePickerController()
    var downURL: String = ""

    let user = Auth.auth().currentUser
    var profileDBModel: [ProfileDBModel] = []
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
//        picker.delegate = self
//
////             Uncomment the following line to preserve selection between presentations
////             self.clearsSelectionOnViewWillAppear = false
//
//            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//            // self.navigationItem.rightBarButtonItem = self.editButtonItem
//
//
//        nickname = defaults.string(forKey: "nickname")!
//        email = defaults.string(forKey: "email")!
////        image = defaults.string(forKey: "profileImage") ?? ""
//        print("image")
//        print(image)
//
//        let profileQueryModel = MyPageProfileQueryModel()
//        profileQueryModel.delegate = self
//        profileQueryModel.downloadItems(email: user!.email!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyPageTableView.reloadData()
    }
    
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        defaults.removeObject(forKey: "nickname")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "password")
        defaults.removeObject(forKey: "autoLogin")
        UserDefaults.standard.synchronize()
        
        let resultAlert = UIAlertController(title: "확인", message: "로그아웃 되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네 알겠습니다.", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
        
        resultAlert.addAction(okAction)
        self.present(resultAlert, animated: true)
        
        
        // 예시 - login 화면 tabBar화면들로 전환
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "MyPageTableView") as! MyPageTableViewController
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "firstController") as! FirstViewController
        self.transition1(from: vc1, to: vc2)
    }
    
    
    func itemDownloaded(items: [ProfileDBModel]) {
        profileDBModel = items

        // url 비동기 통신
        if let imageURL = URL(string: items.first!.profileimage) {
            print(imageURL)
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageFB = image
                    }
                }
            }.resume()
        }

        downURL = profileDBModel.first!.profileimage

        nickname = profileDBModel.first!.nickname
        email = profileDBModel.first!.email


    }

        // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 3
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                   return 1 // profileCell은 1개의 row
               } else if section == 1 {
                   return 1 // payCell은 1개의 row
               } else {
                   return 4 // menuCell은 4개의 row
               }
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                    // profileCell 반환
                    let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
                    // cell 구성
                cell.test(email: user!.email!)
//                if image == "" {
//                    cell.profileImage.image = UIImage(named: "face")
//                } else {
//                    let storage = Storage.storage()
//                    let httpsReference = storage.reference(forURL: image)
//
//                    httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                        if let error = error {
//                            print("Error : \(error)")
//                        }else {
//                            cell.profileImage.image = UIImage(data: data!)
//                        }
//                    }
//                }
//
                
                    return cell
                } else if indexPath.section == 1 {
                    // payCell 반환
                    let cell = tableView.dequeueReusableCell(withIdentifier: "payCell", for: indexPath) as! PayTableViewCell
                    // cell 구성
                    cell.balance.text = "0원"
    //                cell.addBtn
    //                cell.transfer
    //                cell.payGoBtn
                    
                    return cell
                } else {
                    // menuCell 반환
                    let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
                    // cell 구성
                    switch indexPath.row {
                    case 0:
                        cell.menuImage.image = UIImage(named: "heart")
                        cell.menuLabel.text = "관심목록"
    //                    cell.menuGoBtn
                    case 1:
                        cell.menuImage.image = UIImage(named: "list")
                        cell.menuLabel.text = "판매내역"
    //                    cell.menuGoBtn
                    case 2:
                        cell.menuImage.image = UIImage(named: "shop")
                        cell.menuLabel.text = "구매내역"
    //                    cell.menuGoBtn
                    case 3:
                        cell.menuImage.image = UIImage(named: "fullheart")
                        cell.menuLabel.text = "등록된 상품"
    //                    cell.menuGoBtn
                    default:
                        break
                    }
                    
                    return cell
                }
        }
        
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // 각 indexPath에 맞는 셀 높이를 반환합니다.
            //indexPath.row로 하면 안됨
            switch indexPath.section {
                case 0:
                    return 120
                case 1:
                    return 150
                case 2:
                    return 65
                default:
                    return UITableView.automaticDimension
                }
        }

        
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                // Instantiate and present the first view controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MyPageLikeController") as! MyPageLikeTableViewController
                navigationController?.pushViewController(vc, animated: true)
                print("pop")
                print(vc)
            } else if indexPath.row == 1 {
                // Instantiate and present the first view controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TabManViewController") as! TabManViewController
                navigationController?.pushViewController(vc, animated: true)
            }
                // You can add more conditions to handle other cells in this section
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
    // 관심목록 페이지로 전환하는 함수
    func transition(from fromViewController: UIViewController, to toViewController: UIViewController) {
        
        let fromVC = self // 현재 View Controller
        let toVC = storyboard?.instantiateViewController(withIdentifier: "MyPageLikeController") as! MyPageLikeTableViewController // 전환할 View Controller

        fromVC.addChild(toVC)
        fromVC.view.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.bounds
        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toVC.didMove(toParent: fromVC)
    }
    
    // logout후 로그인 페이지로 전환하는 함수
    func transition1(from fromViewController: UIViewController, to toViewController: UIViewController) {
        
        let fromVC = self // 현재 View Controller
        let toVC = storyboard?.instantiateViewController(withIdentifier: "firstController") as! FirstViewController // 전환할 View Controller

        fromVC.addChild(toVC)
        fromVC.view.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.bounds
        toVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toVC.didMove(toParent: fromVC)
    }
    
    
    
}
