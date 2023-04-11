//
//  ChattingViewModel+Cell.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/11.
//

import Foundation

extension DefaultChattingViewModel {
    
    /// 사용자 메세지 셀 추가 (메세지 보냄)
    /// - Parameter content: 보낸 메세지 내용
    func addUserMsgCell(_ content: String) {
        let chat = ChatItem(contents: content, role: .user)
        chatList.append(chat)
    }
    
    /// 사용자 메세지 작성중 셀 추가
    func addUserWritingCell() {
        let writingCell = ChatItem(contents: "", role: .user, state: .writing)
        chatList.append(writingCell)
    }
    
    /// ChatGPT 메세지 셀 추가 (답변 왔음)
    /// - Parameter content: 답변 받은 메세지 내용
    func addAssistantMsgCell(_ content: String) {
        let chatItem = ChatItem(contents: content, role: .assistant)
        self.chatList.append(chatItem)
    }
    
    /// ChatGPT의 답변 대기중 셀 추가
    func addResponseWaitingCell() {
        guard let lastItem = chatList.last else { return }
        
        guard lastItem.state != .responseWaiting else { return }
        
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            let writingCell = ChatItem(contents: "", role: .assistant, state: .responseWaiting)
            self.chatList.append(writingCell)
            
            self.updateChatList()
            self._scrollToBottom.onNext(true)
        }
    }
    
    /// 마지막 셀이 답변 대기중 셀이라면 삭제
    func removeResponseWaitingCell() {
        if let lastItem = chatList.last,
           lastItem.state == .responseWaiting {
            let _ = chatList.popLast()
        }
    }
    
    /// 마지막셀 cellState error로 수정
    func updateErrorCell() {
        guard let lastItem = chatList.popLast() else { return }
        var errorItem = lastItem
        errorItem.state = .error
        
        chatList.append(errorItem)
    }
}
