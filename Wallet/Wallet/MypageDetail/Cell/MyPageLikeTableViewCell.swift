//
//  MyPageLikeTableViewCell.swift
//  Wallet
//
//  Created by Anna Kim on 2023/03/22.
//

import UIKit
import Foundation



class MyPageLikeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var pTitle: UILabel!
    @IBOutlet weak var pBrand: UILabel!
    @IBOutlet weak var pPrice: UILabel!
    
    @IBOutlet weak var btnLikeText: UIButton!
    
    
    @IBOutlet weak var lblState: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        pImage.layer.cornerRadius = pImage.frame.height / 8
        pImage.layer.borderWidth = 0
        pImage.layer.borderColor = UIColor.clear.cgColor
        // 뷰의 경계에 맞춰준다
        pImage.clipsToBounds = true
        
        
    }
    
    
    
    
    @IBAction func btnLike(_ sender: UIButton) {
        
        
    }
    
//    func updateLike(uid: String, imageCode: String, like: String) {
//        let likeUpdate = LikeCodeDB()
//        likeUpdate.delegate = self
//        var likes = like
//
//
//        if like == "1" {
//            likes = "0"
//            btnLikeText?.setImage(UIImage(named: "like1"))
//            likeUpdate.updateItems(uid: uid, imageCode: imageCode, like: likes)
//        } else{
//            likes = "1"
//            btnLikeText?.setImage(UIImage(named: "like2"))
//            likeUpdate.updateItems(uid: uid, imageCode: imageCode, like: likes)
//        }
//
//
//
//        print("Rb??")
//    }
}

