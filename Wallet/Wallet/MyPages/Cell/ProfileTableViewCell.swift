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
    
//    var delegate : ProfileQueryModelProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
//        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
        // imageView Tap
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController())
//        profileImage.isUserInteractionEnabled = true
//        profileImage.addGestureRecognizer(tapGestureRecognizer)

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
    
    func test(email : String){
        let profileQueryModel = MyPageProfileQueryModel()
        profileQueryModel.delegate = self
        profileQueryModel.downloadItems(email: email)
    }

}

extension ProfileTableViewCell :ProfileQueryModelProtocol{
    func itemDownloaded(items: [ProfileDBModel]) {
        let profileDBModel = items

        // url 비동기 통신
        if let imageURL = URL(string: items.first!.profileimage) {
            print(imageURL)
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImage.image = image
                    }
                }
            }.resume()
        }

        nickname.text = profileDBModel.first!.nickname
        email.text = profileDBModel.first!.email
    }
    
    
}
