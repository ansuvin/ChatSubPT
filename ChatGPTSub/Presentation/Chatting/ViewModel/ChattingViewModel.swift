//
//  ChattingViewModel.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/08.
//

import Foundation

import OpenAI

import RxSwift

protocol ViewModelProtocol {
    var disposeBag: DisposeBag { get set }
}

protocol ChattingViewModelInput {
    func viewDidLoad()
    func writingMsg(msg: String?)
    func sendMsg(msg: String?)
}

protocol ChattingViewModelOutput {
    var _updateChatItemList: PublishSubject<Void> { get set }
    
    var _clearInputBar: PublishSubject<Void> { get set }
    var _scrollToBottom: PublishSubject<Bool> { get set }
    
    var _showResendView: PublishSubject<String> { get set }
}

protocol ChattingViewModel: ViewModelProtocol, ChattingViewModelInput, ChattingViewModelOutput {
    var chatList: [ChatItem] { get set }
    
    func getChatItemList() -> [ChatItem]
    func getChatQueryList() -> [Chat]
}

class DefaultChattingViewModel: ChattingViewModel {
    var chatList: [ChatItem] = []
    
    // MARK: Output
    var _updateChatItemList: PublishSubject<Void> = .init()
    
    var _clearInputBar: PublishSubject<Void> = .init()
    var _scrollToBottom: PublishSubject<Bool> = .init()
    
    var _showResendView: PublishSubject<String> = .init()
    
    var disposeBag = DisposeBag()
    
    let openAI = OpenAI(configuration: OpenAI.Configuration(token: "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", timeoutInterval: 30))
    
    func getChatItemList() -> [ChatItem] {
        return chatList
    }
    
    func getChatQueryList() -> [Chat] {
        return chatList.filter({ $0.state != .error }).map({ Chat(role: $0.role, content: $0.contents) })
    }
    
    func viewDidLoad() {
        testAppend()
    }
    
    func testAppend() {
//        chatList.append(ChatItem(contents: "안녕 ChatGPT!", role: .user, insDate: Date()))
//        chatList.append(ChatItem(contents: "네 안녕하세요", role: .assistant, insDate: Date()))
//        chatList.append(ChatItem(contents: "스타벅스에 음료 하나 추천해줘", role: .user, insDate: Date()))
//        chatList.append(ChatItem(contents: "스타벅스에서는 돌체 콜드브루 라떼가 맛있습니다. 더 도와드릴게 있나요?", role: .assistant, insDate: Date()))
        
        chatList.append(ChatItem(contents: "Marv is a chatbot that reluctantly answers questions with sarcastic responses", role: .user, insDate: Date()))
        chatList.append(ChatItem(contents: "어쩔티비", role: .assistant, insDate: Date()))
        
        updateChatList()
    }
    
    func updateChatList() {
        _updateChatItemList.onNext(())
    }

}
