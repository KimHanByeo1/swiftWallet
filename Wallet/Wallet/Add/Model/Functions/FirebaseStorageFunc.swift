//
//  test.swift
//  Wallet
//
//  Created by 김한별 on 2023/03/15.
//

import Foundation
import UIKit
import FirebaseStorage

class FirebaseStorageFunc {
    
    var downURL: String = "" // storage에서 받아온 URL값 저장할 변수
    
    func insertImage(name: String, image: UIImage) {
        let storageRef = Storage.storage().reference()
        
        // File located on disk
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(name).jpg")

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
            StaticModel.downURL = "\(downloadURL)"
          }
        }
        print("--- Completed to insert a image ----")
    }
}
