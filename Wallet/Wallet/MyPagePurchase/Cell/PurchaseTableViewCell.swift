//
//  PurchaseTableViewCell.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/25.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell{

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func test(email : String){
        let profileQueryModel = PurchaseQueryModel()
        profileQueryModel.delegate = self
//        profileQueryModel.downloadItems(purchaseEmail: purchaseEmail)
    }

}

extension PurchaseTableViewCell:PurchaseQueryModelProtocol{
    func itemDownloaded(items: [PurchaseDBModel]) {
        
    }
    
}
