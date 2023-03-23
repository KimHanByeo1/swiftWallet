//
//  ProfileViewController.swift
//  Wallet
//
//  Created by 안수빈 on 2023/03/22.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileQueryModelProtocol {
    

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfName: UITextField!
    
    //    var email = ""
        var nickname = ""
    //    var documentId = ""
        var image = ""
    
    let picker = UIImagePickerController()
    var downURL: String = ""
    
    // 사용자 정보 sharedpreference
    let defaults = UserDefaults.standard
    
    let imagePicker: UIImagePickerController! = UIImagePickerController() // UIImagePickerController의 인스턴스 변수 생성
    var captureImage: UIImage! // 촬영을 하거나 포토 라이브러리에서 불러온 사진을 저장할 변수
//        var videoURL: URL! // 녹화한 비디오의 URL을 저장할 변수
    var flagImageSave = false // 이미지 저장 여뷰를 나타낼 변수
    
    let user = Auth.auth().currentUser
    var profileDBModel: [ProfileDBModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        tfEmail.isUserInteractionEnabled = false
        
        let profileQueryModel = ProfileQueryModel()
        profileQueryModel.delegate = self
        profileQueryModel.downloadItems(email: user!.email!)
        
        // Do any additional setup after loading the view.
                
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tapGestureRecognizer)
        imgView.layer.cornerRadius = imgView.frame.width / 2
        
//        tfName.text = nickname
//        downURL = image
        
//        displayImage()

    }
    
    func itemDownloaded(items: [ProfileDBModel]) {
        print("1")
        profileDBModel = items
        
        // url 비동기 통신
        if let imageURL = URL(string: items.first!.profileimage) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imgView.image = image
                    }
                }
            }.resume()
        }
        
        downURL = profileDBModel.first!.profileimage
        
        print("itemDownloaded: ", downURL)
        
        tfName.text = profileDBModel.first!.nickname
        tfEmail.text = profileDBModel.first!.email
        print("1 end")

        
    }
    
//    func displayImage(){
//        let storage = Storage.storage()
//        let httpsReference = storage.reference(forURL: profileimage)
//
//        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
//          if let error = error {
//              print("Error : \(error)")
//          } else {
//              self.imgView.image = UIImage(data: data!)
//          }
//        }
//
//    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("2")

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
        print("2 end")
    }
    
    
    //이미지 보여주고 문자열로 바꾸기
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("3")

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
        print("3 end")

    }
    
    //이미지 문자로 변경
    func insertImage(name: String){
        
        print("4")

        let storageRef = Storage.storage().reference()

        // File located on disk
        let image = imgView.image!
        
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
                print("downURL : \(self.downURL)")
            }
          }
          print("--- Completed to insert a image ----")
        print("4 end")

    }
    
    @IBAction func btnUpdate(_ sender: UIBarButtonItem) {
        print("5")

        guard let email = tfEmail.text else {return}
               guard let nickname = tfName.text else {return}
               guard let uid = user?.uid else {
                   return
               }
            
            let profileupdatamodel = ProfileUpdataModel()
        print("5 update")

            let result = profileupdatamodel.ProfileUpdataItems(documentId: uid, email: email, nickname: nickname, profileImage: self.downURL)
            
            if result {
                let resultAlert = UIAlertController(title: "완료", message: "수정이 되었습니다.", preferredStyle: UIAlertController.Style.alert)
                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                    self.navigationController?.popViewController(animated: true) // 현재화면 Close
                })
                resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true, completion: nil)
                
            } else {
                let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: UIAlertController.Style.alert)
                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true, completion: nil)
            }
        print("5end")
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
