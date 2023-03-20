//
//  FCollectionReference.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/20.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference:String{
    case User
    case Recent
    case Messages
    case Typing
    case Channel
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
