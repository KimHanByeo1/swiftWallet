//
//  PayTableViewCell.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/21.
//

import UIKit

class PayTableViewCell: UITableViewCell {

    
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    @IBOutlet weak var views: UIView!
    
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
            
            // Add rounded corners to the backView
            let cornerRadius: CGFloat = 10.0 // set the desired corner radius
            backView.layer.cornerRadius = cornerRadius
            backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] // set the desired corners to round
            
            // Add any other customization as needed
        backView.layer.borderWidth = 0.2
            backView.layer.borderColor = UIColor.lightGray.cgColor
//        views.backgroundColor = .white
//        backView.backgroundColor = .white
        
    }
}
