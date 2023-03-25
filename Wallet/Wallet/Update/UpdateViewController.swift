//
//  UpdateViewController.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/23.
//

import UIKit
import FirebaseAuth
import Photos
import FirebaseStorage

class UpdateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, QueryModelProtocal {

    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMaterial: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var tvDetailContent: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var pBrand: String?
    var pMaterial: String?
    var pColor: String?
    var pSize: String?
    var pName: String?
    var pTitle: String?
    var pPrice: String?
    var pContent: String?
    var pDetailContent: String?
    var imgView: String?
    var docId: String?
    
    let currentDate = Date() // Firebase storage에 이미지 등록할 때 '현재 시간.jpg'로 저장하기 위한 생성자
    let formatter = DateFormatter()
    
    let email = Auth.auth().currentUser?.email
    let nickName = UserDefaults.standard.string(forKey: "nickname")
    
    let picker = UIImagePickerController()
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImageSave = false
    var imageData : NSData? = nil
    let photo = UIImagePickerController() // 앨범 이동
    
    var walletStore: [WalletSelectModel] = []
    
    var ct = AddViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NotificationCenter에 옵저버를 추가하여 앱 내에서 발생하는 Action을 컨트롤 한다.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.photo.delegate = self
        self.view.bringSubviewToFront(self.indicator)
        self.indicator.isHidden = true // 첫 화면에선 버퍼링 안보이게 숨기기
        
        picker.delegate = self
        
        // 화면 터치 시 키보드 내리기
        self.hideKeyboard2()
        
//      Text View Placeholder 설정
        tvContent.text = "상품 설명"
        tvContent.textColor = UIColor.lightGray
        tvDetailContent.text = "상품 상세설명"
        tvDetailContent.textColor = UIColor.lightGray
        
//      텍스트 필드 테두리 두께 설정
        tfName.layer.borderWidth = 1
        tfPrice.layer.borderWidth = 1
        tvContent.layer.borderWidth = 1
        tfTitle.layer.borderWidth = 1
        tvDetailContent.layer.borderWidth = 1
        
//      텍스트 필드 테두리 색상 설정
        tfName.layer.borderColor = UIColor.lightGray.cgColor
        tfPrice.layer.borderColor = UIColor.lightGray.cgColor
        tvContent.layer.borderColor = UIColor.lightGray.cgColor
        tfTitle.layer.borderColor = UIColor.lightGray.cgColor
        tvDetailContent.layer.borderColor = UIColor.lightGray.cgColor
        
//      tvDetailContent 입력 못하게 막기
        tvDetailContent.isEditable = false
        
        lblBrand.text = pBrand
        lblMaterial.text = pMaterial
        lblColor.text = pColor
        lblSize.text = pSize
        
        tfName.text = pName
        tfPrice.text = pPrice
        tfTitle.text = pTitle
        
        tvContent.text = pContent
        tvDetailContent.text = pDetailContent
        
        // url 비동기 통신
        if let imageURL = URL(string: imgView!) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }.resume()
        }
        
    }
    
    @IBAction func imageAddBtn(_ sender: UIButton) {
        showAlert()
    }
    
    @IBAction func btnProductUpdate(_ sender: UIBarButtonItem) {

        if imageView.image == nil {
            
        }
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateString = formatter.string(from: currentDate)
        let image = imageView.image!
        
        let storageRef = Storage.storage().reference()
        
        // File located on disk
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(dateString).jpg")

        // Meta data
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // Upload the file to the path "images/rivers.jpg"
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            
            guard metadata != nil else {
                print("Error : FirebaseStorageFunc : putfile")
                return
            }
          // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              print("Error : FirebaseStorageFunc : DownloadURL")
              return
            }
            StaticModel.downURL = "\(downloadURL)"
            self.updateAction()
          }
        }
        
        
    }
    
    
    func updateAction() {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: currentDate)
        
        guard let pBrand = lblBrand.text else {return}
        guard let pMaterial = lblMaterial.text else {return}
        guard let pColor = lblColor.text else {return}
        guard let pSize = lblSize.text else {return}
        guard let pName = tfName.text else {return}
        guard let pPrice = tfPrice.text else {return}
        guard let pContent = tvContent.text else {return}
        guard let pTitle = tfTitle.text else {return}
        guard let pDetailContent = tvDetailContent.text else {return}
        
        if !pName.trimmingCharacters(in: .whitespaces).isEmpty{
            let updateModel = UpdateModel()
            let result = updateModel.UpdateItems(docId: docId!,
                                                 pBrand: pBrand,
                                                 pMaterial: pMaterial,
                                                 pColor: pColor,
                                                 pSize: pSize,
                                                 pName: pName,
                                                 pPrice: pPrice,
                                                 pContent: pContent,
                                                 image: StaticModel.downURL,
                                                 pTitle: pTitle,
                                                 pTime: dateString,
                                                 pDetailContent: pDetailContent,
                                                 nickName: nickName!,
                                                 email: email!
            )
            if result{
                let resultAlert = UIAlertController(title: "완료", message: "수정 되었습니다.", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default,handler: {ACTION in
                    
                    self.navigationController?.popViewController(animated: true)
                })
                
                resultAlert.addAction(onAction)
                present(resultAlert, animated: true)

            }
        } else {
            let resultAlert = UIAlertController(title: "Error", message: "상품 사진을 등록해주세요.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .cancel)
            
            resultAlert.addAction(onAction)
            
            //위에 정의한 것 최종적으로 show
            present(resultAlert, animated: true)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Select One", message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) {(action) in
            PHPhotoLibrary.requestAuthorization({status in
                switch status{
                    // 앨범 열기 권한 허용하면 openPhoto()함수 호출
                    case .authorized:
                        self.openPhoto()
                        break
                    // 앨범 열기 권한 거부
                    case .denied:
                        break
                    // 앨범 열기 불가능
                    case .notDetermined:
                        break
                    // 디폴트
                    default:
                        break
                }
            })
        }
        let camera = UIAlertAction(title: "카메라", style: .default){(action) in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)

    } //showAlert
        
    // 카메라 열기 ——
    func openCamera(){
     
     self.photo.sourceType = .camera
     self.present(self.photo, animated: false, completion: nil)
     
    } //openCamera
     
    // 앨범 열기 ——
    func openPhoto() {
     
         DispatchQueue.main.async {
             self.photo.sourceType = .photoLibrary   //앨범 지정 실시
             self.photo.allowsEditing = false    // 편집 허용 X
             self.present(self.photo, animated: false, completion: nil)
         }
     
    } //openphoto
    
    func itemDownLoaded(items: [WalletSelectModel]) {
        walletStore = items
        lblBrand.text = walletStore.first?.wBrand
        tfName.text = walletStore.first?.wName
        lblSize.text = "길이 \(walletStore.first!.wLength as Int)cm X 높이 \(walletStore.first!.wHeight as Int)cm X 너비 : \(walletStore.first!.wWidth as Double)cm"
        lblColor.text = "색상 : \(walletStore.first!.wColor as String)"
        lblMaterial.text = "소재 : \(walletStore.first!.wMaterial as String)"
        tvDetailContent.text = walletStore.first!.wDetailContent as String
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            
            // 키보드 높이만큼 뷰를 올립니다.
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame.origin.y = -keyboardHeight
            })
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        // 뷰를 원래 위치로 내립니다.
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
} // End

extension UpdateViewController {
    
    // MARK: [사진, 비디오 선택을 했을 때 호출되는 메소드]
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: "public.image" as String){
            if let img = info[UIImagePickerController.InfoKey.originalImage]{
                if flagImageSave {
                    UIImageWriteToSavedPhotosAlbum(img as! UIImage, self, nil, nil)
                }
                // [앨범에서 선택한 사진 정보 확인]
                // [이미지 뷰에 앨범에서 선택한 사진 표시 실시]
                imageView.image = img as? UIImage
                // [이미지 데이터에 선택한 이미지 지정 실시]
                imageData = (img as? UIImage)!.jpegData(compressionQuality: 0.5) as NSData? // jpeg 압축 품질 설정
            }
        }
        // 이미지 피커 닫기
        self.dismiss(animated: true, completion: nil)

        // flask 연동 코드 작성 해야됨
        let flask = Flask()
        
        flask.uploadImg(uiImg: self.imageView.image!)
        flask.predict()
            
        let quertModel = SelectData()
        quertModel.delegate = self
        quertModel.downloadItems()

    }
    
    // MARK: [사진, 비디오 선택을 취소했을 때 호출되는 메소드]
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                
        // 이미지 파커 닫기
        self.dismiss(animated: true, completion: nil)
        
    }
    
}// extension

// 화면 터치 시 키보드 내리는 Function
extension UIViewController {
    func hideKeyboard2() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard2() {
        view.endEditing(true)
    }
}
