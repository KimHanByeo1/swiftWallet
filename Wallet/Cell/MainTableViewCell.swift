//
//  MainTableViewCell.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/20.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBrandAndTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.layer.cornerRadius = imgView.frame.height / 10
        imgView.layer.borderWidth = 0
        imgView.layer.borderColor = UIColor.clear.cgColor
        // 뷰의 경계에 맞춰준다
        imgView.clipsToBounds = true
    }

}
