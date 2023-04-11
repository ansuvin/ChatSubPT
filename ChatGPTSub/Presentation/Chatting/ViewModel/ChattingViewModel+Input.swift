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
        
        addUserMsgCell(content)
        
        updateChatList()
        _scrollToBottom.onNext(false)
        
        sendMsgToGPT()
        
        _clearInputBar.onNext(())
    }
    
    func writingMsg(msg content: String?) {
        guard let lastItem = chatList.last else { return }
        
        if let _ = isValidInputText(content) {
            guard lastItem.state != .writing else { return }
            
            addUserWritingCell()
            
            updateChatList()
            _scrollToBottom.onNext(true)
        } else {
            guard lastItem.state == .writing else { return }
            
            let _ = chatList.popLast()
            
            updateChatList()
            _scrollToBottom.onNext(true)
        }
        
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
