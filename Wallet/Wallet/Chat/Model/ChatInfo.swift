//
//  ChatInfo.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/23.
//

struct ChatInfo{
    var from:String
    var to:String
    
    init(from: String, to: String) {
        self.from = from
        self.to = to
    }
    
    init?(dic: [String:Any]){
        guard let from = dic["from"] as? String, let to = dic["to"] as? String else{return nil}
        self.from = from
        self.to = to
    }
}

extension ChatInfo {
    func toDictionary() -> [String: Any] {
        return ["from": from, "to": to]
    }
}

