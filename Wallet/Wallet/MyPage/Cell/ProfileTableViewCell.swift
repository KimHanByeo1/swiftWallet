//
//  ProfileTableViewCell.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
