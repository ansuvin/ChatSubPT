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
    func sendMsg(msg: String)
}

protocol ChattingViewModelOutput {
    var _chatList: PublishSubject<Void> { get set }
}

protocol ChattingViewModel: ViewModelProtocol, ChattingViewModelInput, ChattingViewModelOutput {
    var chatList: [Chat] { get set }
    
    func getChatList() -> [Chat]
}

class DefaultChattingViewModel: ChattingViewModel {
    var chatList: [Chat] = []
    
    var _chatList: PublishSubject<Void> = .init()
    
    var disposeBag = DisposeBag()
    
    let openAI = OpenAI(apiToken: "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")
    
    func getChatList() -> [Chat] {
        return chatList
    }
    
    func viewDidLoad() {
        testAppend()
    }
    
    func testAppend() {
        chatList.append(Chat(role: .user, content: "안녕 ChatCPT!"))
        chatList.append(Chat(role: .assistant, content: "네 안녕하세요"))
        chatList.append(Chat(role: .user, content: "스타벅스에 음료 하나 추천해줘"))
        chatList.append(Chat(role: .assistant, content: "스타벅스에서는 돌체 콜드브루 라떼가 맛있습니다. 더 도와드릴게 있나요?"))
        
        updateChatList()
    }
    
    func updateChatList() {
        _chatList.onNext(())
    }

}
