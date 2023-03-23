//
//  ChatModel.swift
//  Wallet
//
//  Created by 예띤 on 2023/03/22.
//

import ObjectMapper

class ChatModel: Mappable {

    // 채팅방에 참여한 사람
    public var users: Dictionary<String,Bool> = [:]

    // 채팅방 대화내용
    public var comments: Dictionary<String, Comment> = [:]
    required init?(map:Map){

    }

    func mapping(map:Map){
        users <- map["users"]
        comments <- map["comments"]
    }

    public class Comment: Mappable{
        public var uid: String?
        public var message: String?

        required init?(map:Map){

        }

        public func mapping(map:Map){
            uid <- map["uid"]
            message <- map["message"]
        }
    }
}

//import Foundation
//
//class ChatModel: Codable {
//
//    // 채팅방에 참여한 사람
//    public var users: [String:Bool] = [:]
//
//    // 채팅방 대화내용
//    public var comments: [String:Comment] = [:]
//
//    public class Comment: Codable {
//        public var uid: String?
//        public var message: String?
//
//        public init(uid: String?, message: String?) {
//            self.uid = uid
//            self.message = message
//        }
//    }
//
//    public init(users: [String:Bool], comments: [String:Comment]) {
//        self.users = users
//        self.comments = comments
//    }
//
//}
