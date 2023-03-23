//
//  MyPageTableViewController.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/21.
//

import UIKit

class MyPageTableViewController: UITableViewController {

    
    @IBOutlet var MyPageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
            super.viewDidLoad()

            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false

            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                cell.nickname.text = "nickname"
                cell.email.text = "email@email.email"
                cell.profileImage.image = UIImage(named: "face")
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
                        cell.menuLabel.text = "몰라"
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
