//
//  ChatItem.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/09.
//

import Foundation

import OpenAI

struct ChatItem {
    var contents: String
    var photoUrl: String?
    
    var role: Chat.Role
    
    var insDate: Date
    
    var state: ChatState
    var chatType: ChatType
    
    init(contents: String,
         photoUrl: String? = nil,
         role: Chat.Role,
         insDate: Date = Date(),
         state: ChatState = .normal,
         chatType: ChatType = .text) {
        self.contents = contents
        self.photoUrl = photoUrl
        self.role = role
        self.insDate = insDate
        self.state = state
        self.chatType = chatType
    }
}

enum ChatState {
    case normal
    case writing
    case responseWaiting
    case error
}

enum ChatType {
    case text
    case image
    
    var contentStr: String {
        switch self {
        case .text:
            return ""
        case .image:
            return "를 그려보았어요! 어떤가요?? :)"
        }
    }
}
