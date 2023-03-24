//
//  UsersTableViewController.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/20.
//

import UIKit
import SnapKit

class UsersTableViewController: UITableViewController{
    
    var myChannels:[Channel] = []
    let myEmail = UserDefaults.standard.string(forKey: "email")
    
    @IBOutlet var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    } // viewDidLoad
    
    func viewWillAppear(){
        readvalue()
    }
    
    func readvalue(){
        let downData = downloadData()
        myChannels.removeAll()
        
        downData.delegate = self
        
        downData.downloadItems(myEmail: myEmail!)
        userTableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myChannels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! UserTableViewCell

        cell.lblUserName.text = myChannels[indexPath.row].otherName

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       
        let vc = segue.destination as! NewChatViewController
        
        let cell = sender as! UserTableViewCell
        let indexpath = userTableView.indexPath(for: cell)
        
        vc.destinationUid = myChannels[indexpath!.row].otherEmail
    }
    

} // UsersTableViewController

extension UsersTableViewController:ChannelViewModelProtocol{
    func itemDownLoaded(items: [Channel]) {
        myChannels = items
        self.userTableView.reloadData()
    }
}
