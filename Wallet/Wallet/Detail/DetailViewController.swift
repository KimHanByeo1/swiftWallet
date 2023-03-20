//
//  DetailViewController.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/20.
//

import UIKit

class DetailViewController: UIViewController, DetailModelProtocal {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var lblBrand: UILabel!
    
    var produdctDetailStore: [ProductDetailModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let quertModel = SelectDetailData()
        quertModel.delegate = self
        quertModel.downloadItems()
        
    }
    
    //    //url에 정확한 이미지 url 주소를 넣는다.
    //    let url = URL(string: image.url)
    //    var image : UIImage?
    //        DispatchQueue.global().async {
    //        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
    //        DispatchQueue.main.async {
    //            image = UIImage(data: data!)
    //        }
    //    }
    
    func itemDownLoaded(items: [ProductDetailModel]) {
        produdctDetailStore = items
        let url = URL(string: items.first!.pImageURL)
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
//        lblNickName.text =
        lblProductName.text = produdctDetailStore.first?.pName
        
    }
}
