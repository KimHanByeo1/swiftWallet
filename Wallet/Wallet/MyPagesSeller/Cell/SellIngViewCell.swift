//
//  SellIngViewCell.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/24.
//

import UIKit

class SellIngViewCell: UITableViewCell {

    
    @IBOutlet weak var sellingImage: UIImageView!
    @IBOutlet weak var sellingName: UILabel!
    @IBOutlet weak var sellingBrand: UILabel!
    @IBOutlet weak var sellingPrice: UILabel!
    @IBOutlet weak var sellingStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
