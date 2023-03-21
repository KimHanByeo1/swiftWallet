//
//  DetailViewController.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/20.
//

import UIKit
import FirebaseAuth

class DetailViewController: UIViewController, DetailModelProtocal, UserModelProtocal, SelectDocIdModelProtocal {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var imageView: UIImageView! // 이미지
    @IBOutlet weak var lblNickName: UILabel! // 유저 닉네임
    @IBOutlet weak var lblProductName: UILabel! // 선택한 상품 이름
    @IBOutlet weak var lblTitle: UILabel! // 선택한 상품 제목
    @IBOutlet weak var lblBrandNTime: UILabel! // 선택한 상품 브랜드 및 끌올 시간
    @IBOutlet weak var lblContent: UILabel! // 선택한 상품 상세 내용
    @IBOutlet weak var lblPrice: UILabel! // 선택한 상품 가격
    @IBOutlet weak var btnLikeText: UIButton! // 찜 이미지 변경을 위한 변수
    @IBOutlet weak var userImageView: UIImageView!
    
    var imageURL = "" // MainController에서 넘겨준 imageURL 값 받는 변수
    var like = "" // 찜 여부 확인 0,1
    
    let currentDate = Date() // Firebase storage에 이미지 등록할 때 '현재 시간.jpg'로 저장하기 위한 생성자
    let formatter = DateFormatter()
    
    var productDetailStore: [ProductDetailModel] = []
    var userLikeModel: [UserLikeModel] = []
    var likeModel: [LikeModel] = []
    
    let uid = Auth.auth().currentUser!.uid // 로그인 한 유저의 DocId 가져오기
    let likeVM = LikeViewModel() // 여러개의 function에서 사용하기위해 전역변수로 생성
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let quertModel = SelectDetailData()
        let userModel = UserLikeData()
        
        quertModel.delegate = self
        userModel.delegate = self
        
        userModel.downloadUser(imageURL: imageURL, uid: uid) // 유저가 선택한 상품의 찜 여부 확인을 위한 Select
        quertModel.downloadItems(imageURL: imageURL) // 유저가 선택한 상품의 상세정보 Select
        
    }
    
    // quertModel.downloadItems#imageLiteral(resourceName: "simulator_screenshot_F61D50BF-27DF-470E-8417-6BF159C1B941.png")
    func itemDownLoaded(items: [ProductDetailModel]) {
        
        productDetailStore = items
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date1 = formatter.date(from: formatter.string(from: currentDate))! // 현재 날짜 Date 객체로 변환
        let date2 = formatter.date(from: productDetailStore.first!.pTime)! // DB에서 가져온 날짜 Date 객체로 변환
        
        let calendar = Calendar.current // 현재 달력 객체 생성
        let components = calendar.dateComponents([.hour, .minute, .second], from: date2, to: date1) // 두 날짜 사이의 차이 계산
        let minute = components.minute ?? 0 // 분 차이
        
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
        
        lblNickName.text = defaults.string(forKey: "nickname")!
        lblProductName.text = "상품명: \(productDetailStore.first!.pName)"
        lblTitle.text = productDetailStore.first?.pTitle
        lblBrandNTime.text = "\(productDetailStore.first!.pBrand) · \(minute)분전"
        lblContent.text = productDetailStore.first?.pContent
        lblPrice.text = "\(numberFormatter.string(from: NSNumber(value: Int(productDetailStore.first!.pPrice)!)) ?? "")원"
        
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
