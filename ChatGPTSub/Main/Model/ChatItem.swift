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
    var role: Chat.Role
    
    var insDate: Date
    
    init(contents: String,
         role: Chat.Role,
         insDate: Date = Date()) {
        self.contents = contents
        self.role = role
        self.insDate = insDate
    }
}
