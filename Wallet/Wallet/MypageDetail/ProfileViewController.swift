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
    
    let imagePicker: UIImagePickerController! = UIImagePickerController() // UIImagePickerController의 인스턴스 변수 생성
    var captureImage: UIImage! // 촬영을 하거나 포토 라이브러리에서 불러온 사진을 저장할 변수
//        var videoURL: URL! // 녹화한 비디오의 URL을 저장할 변수
    var flagImageSave = false // 이미지 저장 여뷰를 나타낼 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        // Do any additional setup after loading the view.
        tfNickname.text = nickname
        downURL = profileimage
        
        
//        displayImage()
        
        let imageView = profileImage
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView?.isUserInteractionEnabled = true
            imageView?.addGestureRecognizer(tap)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        // Your action
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                  flagImageSave = false
                  
                  imagePicker.delegate = self
                  imagePicker.sourceType = .photoLibrary
                  imagePicker.mediaTypes = ["public.image"]
                  imagePicker.allowsEditing = true
                  
                  present(imagePicker, animated: true, completion: nil)
              }
              else{
                  myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
              }
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
    
    func myAlert(_ title : String, message : String){
           let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
           alert.addAction(action)
           self.present(alert, animated: true, completion: nil)
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

