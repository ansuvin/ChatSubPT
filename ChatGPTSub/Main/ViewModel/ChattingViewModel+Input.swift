//
//  ChattingViewModel+Input.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/08.
//

import Foundation

import OpenAI

import RxSwift

extension DefaultChattingViewModel {
    func sendMsg(msg content: String) {
        let chat = ChatItem(contents: content, role: .user)
        chatList.append(chat)
        
        updateChatList()
        
        sendMsgToGPT()
    }
    
    func sendMsgToGPT() {
        let query = ChatQuery(model: .gpt3_5Turbo, messages: getChatQueryList(),
                              maxTokens: 256,
                              presencePenalty: 0.6, frequencyPenalty: 0.6)
        
        openAI.chats(query: query) { [weak self] result in
            guard let self = self else { return }
            print("result: \(result)")
            
            switch result {
            case .success(let success):
                print("GPT: \(success.choices.map({$0.message}))")
                guard let chat = success.choices.first?.message else { return }
                let chatItem = ChatItem(contents: chat.content, role: Chat.Role(rawValue: chat.role) ?? .assistant)
                self.chatList.append(chatItem)
                
                self.updateChatList()
            case .failure(let failure):
                print("error: \(failure.localizedDescription)")
            }
        }
    }
}
