//
//  ProfileViewController.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/22.
//

import UIKit
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfName: UITextField!
    
//    var email = ""
//    var nickname = ""
    var profileimage = ""
    
    let picker = UIImagePickerController()
    var downURL: String = ""
    
    // 사용자 정보 sharedpreference
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        // Do any additional setup after loading the view.
        
        displayImage()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        
        let email = defaults.string(forKey: "email")
        let nickname = defaults.string(forKey: "nickname")
        
        tfEmail.text = email
        tfEmail.isUserInteractionEnabled = false
        tfName.text = nickname
        downURL = profileimage

    }
    
    func displayImage(){
        let storage = Storage.storage()
        let httpsReference = storage.reference(forURL: profileimage)
        
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
              print("Error : \(error)")
          } else {
              self.imgView.image = UIImage(data: data!)
          }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        // Your action
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
    
    @IBAction func btnUpdate(_ sender: UIBarButtonItem) {
        guard let email = tfEmail.text else {return}
        guard let nickname = tfName.text else {return}
        let image = downURL
        
        let updateModel = ProfileUpdataModel()
        let result = updateModel.ProfileUpdataItems(email: email, nickname: nickname, profileImage: image)
        
        if result == true{
            let resultAlert = UIAlertController(title: "완료", message: "수정이 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true) // 현재화면 Close
            })
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }else{
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
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
