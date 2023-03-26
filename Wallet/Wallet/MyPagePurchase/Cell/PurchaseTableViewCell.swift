//
//  PurchaseTableViewCell.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/25.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pTitle: UILabel!
    @IBOutlet weak var pPrice: UILabel!
    @IBOutlet weak var usersLike: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews(){
        
    }

}
