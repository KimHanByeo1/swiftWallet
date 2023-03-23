//
//  ProfileTableViewCell.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        profileImage.layer.cornerRadius = profileImage.frame.width / 2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // border 깎기
//        profileImage.layer.cornerRadius = profileImage.frame.width / 2
//        profileImage.clipsToBounds = true
//
//        // Add a stroke to the image
////            profileImage.layer.borderWidth = 1.0
////            profileImage.layer.borderColor = UIColor.black.cgColor
//
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.borderWidth = 0
        profileImage.layer.borderColor = UIColor.clear.cgColor
        // 뷰의 경계에 맞춰준다
        profileImage.clipsToBounds = true
    }

}
