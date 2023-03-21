//
//  PayTableViewCell.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/21.
//

import UIKit

class PayTableViewCell: UITableViewCell {

    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var transfer: UIButton!
    @IBOutlet weak var payGoBtn: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
