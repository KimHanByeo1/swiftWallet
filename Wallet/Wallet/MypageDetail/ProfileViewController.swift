//
//  ProfileViewController.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/21.
//

import UIKit
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var tfNickname: UITextField!
    
    var documentID = ""
    var nickname = ""
    var profileimage = ""
    
    let picker = UIImagePickerController()
    var downURL: String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        // Do any additional setup after loading the view.
        tfNickname.text = nickname
        downURL = profileimage

        displayImage()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: touchToPickPhoto())
//        profileImage.addGestureRecognizer(tapGesture)
//        profileImage.isUserInteractionEnabled

    }
    
    func displayImage(){
        let storage = Storage.storage()
        let httpsReference = storage.reference(forURL: profileimage)

        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
              print("Error : \(error)")
          } else {
//              self.profileimage.image = UIImage(data: data!)
          }
        }
    }
    
    func touchToPickPhoto() {
      //code
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
