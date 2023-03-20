//
//  AddViewController.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/14.
//

// 앨범에서 이미지 선택하기
// 선택한 이미지에 관련된 데이터 파이어베이스에서 불러오기
// 이미지 코드는 0 또는 1


import UIKit
import Photos
import FirebaseStorage
import MobileCoreServices

class AddViewController: UIViewController, QueryModelProtocal, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var lblBrand: UILabel! // 상품 브랜드
    @IBOutlet weak var lblMaterial: UILabel! // 상품 소재
    @IBOutlet weak var lblColor: UILabel! // 상품 색상
    @IBOutlet weak var lblSize: UILabel! // 상품 사이즈
    
    @IBOutlet weak var tfName: UITextField! // 상품 이름
    @IBOutlet weak var tfPrice: UITextField! // 상품 가격
    @IBOutlet weak var tvContent: UITextView! // 상품 설명
    @IBOutlet weak var imageView: UIImageView! // 상품 이미지
    @IBOutlet weak var indicator: UIActivityIndicatorView! // 예측 데이터 가져올 때 화면 동작 멈추게 할 indicatorView
    
    let currentDate = Date() // Firebase storage에 이미지 등록할 때 '현재 시간.jpg'로 저장하기 위한 생성자
    let formatter = DateFormatter()
    
    let picker = UIImagePickerController()
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImageSave = false
    
    var walletStore: [WalletSelectModel] = []
    
    var imageData : NSData? = nil
    let photo = UIImagePickerController() // 앨범 이동
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photo.delegate = self
        self.view.bringSubviewToFront(self.indicator)
        self.indicator.isHidden = true // 첫 화면에선 버퍼링 안보이게 숨기기
        
        picker.delegate = self
        
//      화면 터치 시 키보드 내리기
        self.hideKeyboard()
        
        tvContent.delegate = self
        
//      Text View Placeholder 설정
        tvContent.text = "상품 설명"
        tvContent.textColor = UIColor.lightGray
        
//      텍스트 필드 테두리 두께 설정
        tfName.layer.borderWidth = 1
        tfPrice.layer.borderWidth = 1
        tvContent.layer.borderWidth = 1
        
//      텍스트 필드 테두리 색상 설정
        tfName.layer.borderColor = UIColor.lightGray.cgColor
        tfPrice.layer.borderColor = UIColor.lightGray.cgColor
        tvContent.layer.borderColor = UIColor.lightGray.cgColor
        
//      기본 이미지 설정
        imageView.image = UIImage(named: "basicImage")

    }
    
//  Placeholder 설정
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvContent.text.isEmpty {
            tvContent.text =  "상품 설명"
            tvContent.textColor = UIColor.lightGray
        }
    }
//  텍스트 필드 클릭 시 널 값으로 초기화
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tvContent.textColor == UIColor.lightGray {
            tvContent.text = nil
            tvContent.textColor = UIColor.black
        }
    }
    
//  ==================== Button Start ====================
    // 앨범에서 이미지 가져오기
    @IBAction func imageAddBtn(_ sender: UIButton) {
        showAlert()
    }
    // 입력한 상세정보들 Firebase에 등록
    @IBAction func btnProductRegister(_ sender: UIButton) {
        
        guard let wBrand = lblBrand.text else {return}
        guard let wMaterial = lblMaterial.text else {return}
        guard let wColor = lblColor.text else {return}
        guard let wSize = lblSize.text else {return}
        guard let wName = tfName.text else {return}
        guard let wPrice = tfPrice.text else {return}
        guard let wContent = tvContent.text else {return}
        
        if !wName.trimmingCharacters(in: .whitespaces).isEmpty{
            let prModel = ProductRegisterModel()
            let result = prModel.insesrtItems(
                wBrand: wBrand,
                wMaterial: wMaterial,
                wColor: wColor,
                wSize: wSize,
                wName: wName,
                wPrice: wPrice,
                wContent: wContent,
                image: StaticModel.downURL)

            if result{
                let resultAlert = UIAlertController(title: "완료", message: "입력이 되었습니다.", preferredStyle: .alert)
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
    
    
//  ==================== Button End ======================
    
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
    
    // Firebaase에서 가져온 데이터들 각각의 텍스트필드 및 레이블에 값 지정
    func itemDownLoaded(items: [WalletSelectModel]) {
        walletStore = items
        lblBrand.text = walletStore.first?.wBrand
        tfName.text = walletStore.first?.wName
        lblSize.text = "길이 \(walletStore.first!.wLength as Int)cm X 높이 \(walletStore.first!.wHeight as Int)cm X 너비 : \(walletStore.first!.wWidth as Double)cm"
        lblColor.text = "색상 : \(walletStore.first!.wColor as String)"
        lblMaterial.text = "소재 : \(walletStore.first!.wMaterial as String)"
        
    } // itemDownLoaded
    
} // End

// ---------------- extension Start ----------------

extension AddViewController {
    
    // MARK: [사진, 비디오 선택을 했을 때 호출되는 메소드]
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: currentDate)

        let image = imageView.image!

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
        let fsFunc = FirebaseStorageFunc()

        // FirebaseStorageFunc Folder
        fsFunc.insertImage(name: dateString, image: image)
        // 이미지 피커 닫기
        self.dismiss(animated: true, completion: nil)

        // flask 연동 코드 작성 해야됨
        let flask = Flask()

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.last

        self.indicator.isHidden = false
        indicator.frame = window!.frame
        self.indicator.startAnimating()

        flask.uploadImg(uiImg: self.imageView.image!)
        flask.predict()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            let quertModel = SelectData()
            quertModel.delegate = self
            quertModel.downloadItems()

            self.indicator.isHidden = true
            self.indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

            window!.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
            self.indicator.stopAnimating()
        }
        
    }
    
    // MARK: [사진, 비디오 선택을 취소했을 때 호출되는 메소드]
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                
        // 이미지 파커 닫기
        self.dismiss(animated: true, completion: nil)
        
    }
    
}// extension

// 화면 터치 시 키보드 내리는 Function
extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
