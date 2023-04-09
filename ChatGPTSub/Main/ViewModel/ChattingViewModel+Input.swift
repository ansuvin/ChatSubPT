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
    func sendMsg(msg content: String?) {
        guard let content = isValidInputText(content) else { return }
        
        if let lastItem = chatList.last,
           lastItem.state == .writing {
            let _ = chatList.popLast()
        }
        
        let chat = ChatItem(contents: content, role: .user)
        chatList.append(chat)
        
        updateChatList()
        
        sendMsgToGPT()
        
        _clearInputBar.onNext(())
    }
    
    func writingMsg(msg content: String?) {
        guard let lastItem = chatList.last else { return }
        
        if let _ = isValidInputText(content) {
            guard lastItem.state != .writing else { return }
            
            let writingCell = ChatItem(contents: "", role: .user, state: .writing)
            chatList.append(writingCell)
            
            updateChatList()
        } else {
            guard lastItem.state == .writing else { return }
            
            let _ = chatList.popLast()
            
            updateChatList()
        }
        
    }
    
    func sendMsgToGPT() {
        addResponseWaitingCell()
        
        print("sendMSGToGPT")
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
                
                if let lastItem = chatList.last,
                   lastItem.state == .responseWaiting {
                    let _ = chatList.popLast()
                }
                
                let chatItem = ChatItem(contents: chat.content, role: Chat.Role(rawValue: chat.role) ?? .assistant)
                self.chatList.append(chatItem)
                
                self.updateChatList()
            case .failure(let failure):
                print("error: \(failure.localizedDescription)")
            }
        }
    }
    
    func addResponseWaitingCell() {
        guard let lastItem = chatList.last else { return }
        
        guard lastItem.state != .responseWaiting else { return }
        
        let writingCell = ChatItem(contents: "", role: .assistant, state: .responseWaiting)
        chatList.append(writingCell)
        
        updateChatList()
    }
    
    func isValidInputText(_ msg: String?) -> String? {
        guard let text = msg,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              text != "Enter message" else {
            return nil
        }
        
        return text
    }
}
