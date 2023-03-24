//
//  SellFinViewCell.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/24.
//

import UIKit

class SellFinViewCell: UITableViewCell {

    
    @IBOutlet weak var sellFinImage: UIImageView!
    @IBOutlet weak var sellFinName: UILabel!
    @IBOutlet weak var sellFinBrand: UILabel!
    @IBOutlet weak var sellFinPrice: UILabel!
    @IBOutlet weak var sellFinStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
