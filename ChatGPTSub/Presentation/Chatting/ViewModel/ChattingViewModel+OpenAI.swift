//
//  ChattingViewModel+OpenAI.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/11.
//

import Foundation

import OpenAI

import RxSwift

extension DefaultChattingViewModel {
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
                
                self.removeResponseWaitingCell()
                
                addAssistantMsgCell(chat.content)
                
                self.updateChatList()
                self._scrollToBottom.onNext(true)
                
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                
                self.removeResponseWaitingCell()
                self.updateErrorCell()
                
                guard let lastItem = self.chatList.last,
                      let text = self.isValidInputText(lastItem.contents) else { return }
                self._showResendView.onNext(text)
            }
        }
    }
    
    func sendReqImageToGPT(content reqStr: String) {
        
        print("sendReqImageToGPT")
        var prompt = reqStr.replacingOccurrences(of: "그려줘", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        let query = ImagesQuery(prompt: prompt, n: 1, size: .size1024)
        
        openAI.images(query: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                print("GPT Image: \(success.data.first?.url)")
                
                guard let url = success.data.first?.url else { return }
                let imageCell = ChatItem(contents: prompt, photoUrl: url, role: .assistant, chatType: .image)
                self.chatList.append(imageCell)
                
                self.updateChatList()
                self._scrollToBottom.onNext(true)
                
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
}

extension String {
    static let size256 = "256x256"
    static let size512 = "512x512"
    static let size1024 = "1024x1024"
}
