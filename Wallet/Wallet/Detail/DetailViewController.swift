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
    
    let firebaseDB = Firestore.firestore()
    var chatRoomUid:String?
    var check:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let quertModel = SelectDetailData()
        let userModel = UserLikeData()
        
        quertModel.delegate = self
        userModel.delegate = self
        
        userModel.downloadUser(imageURL: imageURL, uid: uid) // 유저가 선택한 상품의 찜 여부 확인을 위한 Select
        quertModel.downloadItems(imageURL: imageURL) // 유저가 선택한 상품의 상세정보 Select
        
        // 채팅내역이 있는지 확인
        check = checkChatRoom()
        
    }
    
    @IBAction func goChating(_ sender: UIButton) {
        if check == 0 {
            createRoom()
        }
    }
    
    // 채팅 여부 확인
    func checkChatRoom() -> Int{
        
        firebaseDB.collection("chatrooms").getDocuments(completion: {(querySnapShot, err) in
            
            for doc in querySnapShot!.documents{
                
                guard let first = doc.data()["first"] as? String, let second = doc.data()["second"] as? String else{return}
                
                print(first, second)
                print(self.defaults.string(forKey: "email")!)
                print(self.userEmail!)
                
                if (first == self.defaults.string(forKey: "email")! && second == self.userEmail!) ||
                    (first == self.userEmail!) && second == self.defaults.string(forKey: "email")!{
                    self.check = 1
                    break
                }else{
                    self.check = 0
                }
            }
        })
        return check ?? 0
    }
    
    // 채팅방 생성
    func createRoom(){
        
        firebaseDB.collection("chatrooms").addDocument(data: [
            "first" : defaults.string(forKey: "email")!,
            "second" : userEmail!
        ])
        
//        let createRoomInfo:Dictionary<String,Any> = [
//            "users":[
//                "from": defaults.string(forKey: "email"),
//                "to": userEmail
//            ]
//        ]
        
//        if chatRoomUid == nil{
//            // 방 생성 코드
//            Database.database().reference().child("chatrooms").childByAutoId().setValue(, withCompletionBlock: {(err, ref) in
//                if err == nil{
////                    self.checkChatRoom()
//                }
//            })
//        }else{
//
//        }
        
        
    }
    
//    func checkChatRoom(){
//        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/to").queryEqual(toValue: userEmail).observeSingleEvent(of: DataEventType.value, with: {datasnapshot in
//
//            print(datasnapshot.children.allObjects as! [DataSnapshot])
//
//            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
//
//                if let chatRoomdic = item.value as? [String:AnyObject]{
//                    print(chatRoomdic["users"])
//
//                    var chatInfo : [ChatInfo] = []
//
////                    let chatModel = ChatModel(JSON: chatRoomdic)
////                    if chatModel?.users["from"] == userEmail{
////                        self.chatRoomUid = item.key
////                    }
//                }
//            }
//        })
//    }
    
    
//        firebaseDB.child("chatrooms").observe(.value, with: {snapshot in
//
//            let chatDic = snapshot.value as? [String:Any] ?? [:]
//            for (key, value) in chatDic{
//                print(value)
//            }

//            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
//
//                if let chatRoomdic = item.value as? [String:AnyObject]{
//                    print(chatRoomdic["users"])
//
//                    var chatInfo : [ChatInfo] = []
//
////                    let chatModel = ChatModel(JSON: chatRoomdic)
////                    if chatModel?.users["from"] == userEmail{
////                        self.chatRoomUid = item.key
////                    }
//                }
//            }
//        })

    
    // quertModel.downloadItems
    func itemDownLoaded(items: [ProductDetailModel]) {
        
        productDetailStore = items
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        // url 비동기 통신
        if let imageURL = URL(string: items.first!.pImageURL) {
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
        lblPrice.text = "\(numberFormatter.string(from: NSNumber(value: Int(productDetailStore.first!.pPrice)!)) ?? "")원"
        lblDetailContent.text = productDetailStore.first?.pDetailContent
        
        userNickName = productDetailStore.first?.userNickName
        userEmail = productDetailStore.first?.userEmail
        
        if productDetailStore.first?.pState == "1" {
            chat.titleLabel?.text = "판매완료"
            chat.isEnabled = false
        } else {
            chat.titleLabel?.text = "채팅하기"
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
    
}
