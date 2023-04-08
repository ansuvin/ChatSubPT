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
        let chat = Chat(role: .user, content: content)
        chatList.append(chat)
        
        updateChatList()
        
        sendMsgToGPT()
    }
    
    func sendMsgToGPT() {
        let query = ChatQuery(model: .gpt3_5Turbo, messages: self.chatList,
                              maxTokens: 256,
                              presencePenalty: 0.6, frequencyPenalty: 0.6)
        
        openAI.chats(query: query) { [weak self] result in
            guard let self = self else { return }
            print("result: \(result)")
            
            switch result {
            case .success(let success):
                print("GPT: \(success.choices.map({$0.message}))")
                guard let chat = success.choices.first?.message else { return }
                self.chatList.append(chat)
                
                self.updateChatList()
            case .failure(let failure):
                print("error: \(failure.localizedDescription)")
            }
        }
    }
}
