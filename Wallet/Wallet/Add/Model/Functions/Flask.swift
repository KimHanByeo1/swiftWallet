//
//  Flask.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/15.
//

// Flask서버로 이미지 전송하는 코드

import Foundation
import UIKit

class Flask {
    func uploadImg(uiImg: UIImage) {

        let url = URL(string: "http://127.0.0.1:5000/createUserModel")!
        let boundary = UUID().uuidString // 임의의 문자열로 구분자 생성

        // 요청 객체 생성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // 요청의 본문 생성
        let imageData = (uiImg.jpegData(compressionQuality: 1.0)!)
        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body as Data

        // URLSession 객체 생성 및 전송
        let session = URLSession.shared
        let task = session.uploadTask(with: request, from: nil) { data, response, error in
            // 응답 처리/Users/hanbyeol/Documents/GitHub/swiftWallet/Wallet/Wallet/Add/Model/Functions/Flask.swift
        }
        task.resume()
    }
    
    func predict() {
        let urlPath = "http://127.0.0.1:5000/predict"
        let url2: URL = URL(string: urlPath)!
        
        guard let data = try? Data(contentsOf: url2) else { return }
        let decoder = JSONDecoder()
        
        do{
            let resultData = try decoder.decode(Result.self, from: data)

            StaticModel.wCode = Int(resultData.result)!
            
        }catch let error{
            print("Fail : \(error.localizedDescription)")
        }
    }
    
}
