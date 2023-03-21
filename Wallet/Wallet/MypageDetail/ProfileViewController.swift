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
        
        var imageView = profileImage
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector(("imageTapped:")))
        imageView!.isUserInteractionEnabled = true
        imageView?.addGestureRecognizer(tapGestureRecognizer)

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
    
    func imageTapped(img: AnyObject)
    {
        let photoAlert = UIAlertController(title: "사진 가져오기", message: "Photo Library에서 사진을 가져 옵니다.", preferredStyle: UIAlertController.Style.actionSheet) // Alert가 화면 밑에서 돌출
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: false, completion: nil) // animated: true로 해서 차이점을 확인해 보세요!
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        photoAlert.addAction(okAction)
        photoAlert.addAction(cancelAction)
        
        present(photoAlert, animated: true, completion: nil)
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
