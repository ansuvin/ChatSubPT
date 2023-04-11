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
            case .failure(let failure):
                print("error: \(failure.localizedDescription)")
                
                self.removeResponseWaitingCell()
                self.updateErrorCell()
                
                guard let lastItem = self.chatList.last,
                      let text = self.isValidInputText(lastItem.contents) else { return }
                self._showResendView.onNext(text)
            }
        }
    }
}
