//
//  DetailViewController.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class DetailViewController: UIViewController, DetailModelProtocal, UserModelProtocal, SelectDocIdModelProtocal {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var imageView: UIImageView! // 이미지
    @IBOutlet weak var lblNickName: UILabel! // 유저 닉네임
    @IBOutlet weak var lblTitle: UILabel! // 선택한 상품 제목
    @IBOutlet weak var lblProductName: UILabel! // 선택한 상품 이름
    @IBOutlet weak var lblBrandNTime: UILabel! // 선택한 상품 브랜드 및 끌올 시간
    @IBOutlet weak var lblDetailContent: UILabel!
    @IBOutlet weak var lblContent: UILabel! // 선택한 상품 상세 내용
    @IBOutlet weak var lblPrice: UILabel! // 선택한 상품 가격
    @IBOutlet weak var btnLikeText: UIButton! // 찜 이미지 변경을 위한 변수
    @IBOutlet weak var chat: UIButton!
    
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var imageURL = "" // MainController에서 넘겨준 imageURL 값 받는 변수
    var like = "" // 찜 여부 확인 0,1
    
    let currentDate = Date() // Firebase storage에 이미지 등록할 때 '현재 시간.jpg'로 저장하기 위한 생성자
    let formatter = DateFormatter()
    
    var productDetailStore: [ProductDetailModel] = []
    var userLikeModel: [UserLikeModel] = []
    var likeModel: [LikeModel] = []
    
    let uid = Auth.auth().currentUser!.uid // 로그인 한 유저의 DocId 가져오기
    let likeVM = LikeViewModel() // 여러개의 function에서 사용하기위해 전역변수로 생성
    
    var userNickName: String?
    var userEmail: String?
    var userId: String?
    
    let firebaseDB = Firestore.firestore()
    var chatRoomUid:String?
    var check:Int?
    var myName = UserDefaults.standard.string(forKey: "nickname")
    
    let user = Auth.auth().currentUser! // 로그인 한 유저 정보 가져오기
    var productDocId: String?
    
    override func viewWillAppear(_ animated: Bool) {
        let quertModel = SelectDetailData()
        let userModel = UserLikeData()

        quertModel.delegate = self
        userModel.delegate = self

        userModel.downloadUser(imageURL: imageURL, uid: user.uid) // 유저가 선택한 상품의 찜 여부 확인을 위한 Select
        
        if ProductStatic.num == 0 {
            quertModel.downloadItems(imageURL: imageURL) // 유저가 선택한 상품의 상세정보 Select
        } else {
            quertModel.downloadItems2(docId: ProductStatic.docId) // 유저가 선택한 상품의 상세정보 Select
            ProductStatic.num = 0
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let quertModel = SelectDetailData()
//        let userModel = UserLikeData()
//
//        quertModel.delegate = self
//        userModel.delegate = self
//
//        userModel.downloadUser(imageURL: imageURL, uid: uid) // 유저가 선택한 상품의 찜 여부 확인을 위한 Select
//        quertModel.downloadItems(imageURL: imageURL) // 유저가 선택한 상품의 상세정보 Select
        
        btnDelete.isHidden = true
        btnUpdate.isHidden = true
        chat.isHidden = true
        btnLikeText.isHidden = true
        line.isHidden = true
        lblPrice.isHidden = true
        
        // 채팅내역이 있는지 확인
        check = checkChatRoom()
        
    }
    
    @IBAction func goChating(_ sender: UIButton) {
//        if check == 0 {
//            createRoom()
//        }
    }
    
    // 채팅 여부 확인
    func checkChatRoom() -> Int{
        
        firebaseDB.collection("chatrooms").document(uid).collection("you").getDocuments(completion: {(querySnapShot, err) in
            
            for doc in querySnapShot!.documents{
                if doc.documentID == self.userId{
                    self.check = 1
                    break
                }
            }
        })
        return check ?? 0
    }
    
    // 채팅방 생성
    func createRoom(){
        
        firebaseDB.collection("chatrooms").document(uid).collection("you").document(userNickName!).collection("Messages").document().setData([
            "Message": "Hi"
        ])
        firebaseDB.collection("chatrooms").document(userId!).collection("you").document(myName!).collection("Messages").document().setData([
            "Message": "Hello"
        ])
    }
    
    // quertModel.downloadItems
    func itemDownLoaded(items: [ProductDetailModel]) {
        productDetailStore = items
        
        ProductStatic.docId = productDetailStore.first!.docId
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        // url 비동기 통신
        if let imageURL = URL(string: productDetailStore.first!.pImageURL) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }.resume()
        }
        
        let dateViewModel = DateViewModel()
        
        lblNickName.text = productDetailStore.first?.userNickName
        lblProductName.text = "상품명: \(productDetailStore.first!.pName)"
        lblTitle.text = productDetailStore.first?.pTitle
        lblBrandNTime.text = "\(productDetailStore.first!.pBrand) · \(dateViewModel.DateCount(productDetailStore.first!.pTime))"
        lblContent.text = productDetailStore.first?.pContent
        lblDetailContent.text = productDetailStore.first?.pDetailContent
        
        userNickName = productDetailStore.first?.userNickName
        userEmail = productDetailStore.first?.userEmail
        userId = productDetailStore.first?.uid
        productDocId = productDetailStore.first?.docId
        
        let textSize = lblPrice.intrinsicContentSize
        
        if productDetailStore.first?.pState == "1" { // 상품 거래가 완료 되었으면
            lblPrice.frame.size = textSize
            lblPrice.text = "판매 완료된 상품입니다."
        } else {
            lblPrice.frame.size = textSize
            lblPrice.text = "\(numberFormatter.string(from: NSNumber(value: Int(productDetailStore.first!.pPrice)!)) ?? "")원"
            if productDetailStore.first?.userEmail == user.email {
                btnDelete.isHidden = false // 삭제 버튼 On
                btnUpdate.isHidden = false // 수정 버튼 On
            } else {
                chat.isHidden = false // 채팅하기 버튼 On
                btnLikeText.isHidden = false // 찜 버튼 On
                line.isHidden = false
                lblPrice.isHidden = false
            }
        }
    }
    
    // userModel.downloadUser
    func userItemDownLoaded(items: [UserLikeModel]) {
        
        userLikeModel = items
        
        like = userLikeModel.first?.like ?? "0"
        
        if (like == "1") { // 1 이면 yes찜
            btnLikeText.setImage(UIImage(named: "like2"), for: .normal)
        } else { // 0 이면 no찜
            btnLikeText.setImage(UIImage(named: "like1"), for: .normal)
        }
        
    }
    
    @IBAction func btnLike(_ sender: UIButton) {
        
        if (like == "0") { // no찜 -> yes찜
            btnLikeText.setImage(UIImage(named: "like2"), for: .normal)
            like = "1"
            
            // Insert (나 찜 했다!)
            likeVM.insesrtItems(
                    uid: uid,
                    code: imageURL,
                    like: like)
            
        } else { // yes찜 -> no찜
            btnLikeText.setImage(UIImage(named: "like1"), for: .normal)
            like = "0"
            
            // 삭제를 위한 Like 컬렉션의 문서ID 가져오는 쿼리
            let likeViewModel = LikeViewModel()
            likeViewModel.delegate = self
            likeViewModel.SelectDocId(imageURL: imageURL, uid: uid)
            
        }
    }
    
    func SelectDocId(items: [LikeModel]) {
        likeModel = items
        
        // 문서ID로 삭제하는 쿼리
        likeVM.DeleteItems(
            // likeModel.first?.docId ?? "" << 가져온 문서ID
            docId: likeModel.first?.docId ?? "",
            uid: uid)
    }
    
    // MARK: - Navigation (Segue 처리)

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgUpdate" {
            
            let view = segue.destination as! UpdateViewController

            view.pBrand = productDetailStore.first!.pBrand
            view.pSize = productDetailStore.first!.pSize
            view.pColor = productDetailStore.first!.pColor
            view.pMaterial = productDetailStore.first!.pMaterial

            view.pName = productDetailStore.first!.pName
            view.pTitle = productDetailStore.first!.pTitle
            view.pPrice = productDetailStore.first!.pPrice

            view.pContent = productDetailStore.first!.pContent
            view.pDetailContent = productDetailStore.first!.pDetailContent

            view.imgView = productDetailStore.first!.pImageURL
            
            view.docId = productDetailStore.first!.docId
            
        } else {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            let vc = segue.destination as! NewChatViewController
        
            
            vc.currentUser = Sender(senderId: uid, displayName: defaults.string(forKey: "nickname")!)
            
            vc.otherUser = Sender(senderId: userId!, displayName: userNickName!)
        }
        
        
    }
    
    @IBAction func productUpdate(_ sender: UIButton) {
        performSegue(withIdentifier: "sgUpdate", sender: sender)
        ProductStatic.num = 1
    }
    
    @IBAction func productDelete(_ sender: UIButton) {
        let testAlert = UIAlertController(title: "삭제", message: "삭제 하시겠습니까?", preferredStyle: .alert)
        
        let actionDefault = UIAlertAction(title: "예", style: .default, handler: {ACTION in
            Firestore.firestore().collection("product")
                .document(self.productDocId!)
                .delete()
            self.navigationController?.popViewController(animated: true)
        })
        let actionDestructive = UIAlertAction(title: "아니오", style: .destructive, handler: nil)
        
        testAlert.addAction(actionDefault)
        testAlert.addAction(actionDestructive)
        
        present(testAlert, animated: true)
    }
    
    
}
