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
    var documentId = ""
    var profileimage = ""
    
    let picker = UIImagePickerController()
    var downURL: String = ""
    
    // 사용자 정보 sharedpreference
    let defaults = UserDefaults.standard
    
    let imagePicker: UIImagePickerController! = UIImagePickerController() // UIImagePickerController의 인스턴스 변수 생성
    var captureImage: UIImage! // 촬영을 하거나 포토 라이브러리에서 불러온 사진을 저장할 변수
//        var videoURL: URL! // 녹화한 비디오의 URL을 저장할 변수
    var flagImageSave = false // 이미지 저장 여뷰를 나타낼 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        // Do any additional setup after loading the view.
        
//        displayImage()
        
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
        _ = tapGestureRecognizer.view as! UIImageView

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
        print("email : \(email)")
        print("nickname : \(nickname)")
        print("image : \(self.downURL)")
        //        let image = downURL
        
        let profileupdatamodel = ProfileUpdataModel()
        let result = profileupdatamodel.ProfileUpdataItems(documentId: documentId, email: email, nickname: nickname, profileImage: self.downURL)
        
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
    
    
    //이미지 보여주고 문자열로 바꾸기
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: "public.image" as String){
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            if flagImageSave{
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            imgView.image = captureImage
            print("image.Image : \(String(describing: captureImage))")
        }
        insertImage(name: tfName.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    //이미지 문자로 변경
    func insertImage(name: String){
        let storageRef = Storage.storage().reference()

        // File located on disk
        let image = imgView.image!
        print(image)
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        print("imageData: \(imageData)")
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(name).jpg")
        print("imageRef : \(imageRef)")

        // Meta data
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        // Upload the file to the path "images/rivers.jpg"
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            guard metadata != nil else {
            print("Error : putfile")
            return
          }
          // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              print("Error : DownloadURL")
              return
            }
              self.downURL = "\(downloadURL)"
                print("imageURL : \(self.downURL)")
          }
        }
        print("--- Completed to insert a image ----")

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
