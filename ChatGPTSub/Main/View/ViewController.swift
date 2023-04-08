//
//  ViewController.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/07.
//

import UIKit

import Then
import SnapKit
import PinLayout

import OpenAI

import RxSwift

class ViewController: UIViewController {
    
    var layoutModel = ChattingLayout()
    
    var disposeBag = DisposeBag()
    
    let openAI = OpenAI(apiToken: "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")
    
    var chatStory: [Chat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        layoutModel.viewDidLoad(superView: self.view)
        
        
        bind()
        setDelegate()
        
        testAppend()
    }
    
    func testAppend() {
        chatStory.append(Chat(role: .user, content: "안녕 ChatCPT!"))
        chatStory.append(Chat(role: .system, content: "네 안녕하세요"))
        chatStory.append(Chat(role: .user, content: "스타벅스에 음료 하나 추천해줘"))
        chatStory.append(Chat(role: .system, content: "스타벅스에서는 돌체 콜드브루 라떼가 맛있습니다. 더 도와드릴게 있나요?"))
        
        layoutModel.tableViewUpdate()
    }

    func sayHelloGPT() {
        let query = CompletionsQuery(model: .textDavinci_003, prompt: "Hi! Say hello~",
                                     maxTokens: 100,
                                     frequencyPenalty: 0.6,
                                     presencePenalty: 0.6,
                                     stop: ["끝", "그만", "ㅅㄱ"])
        
        openAI.completions(query: query) { result in
            print("result: \(result)")
        }
    }
    
    func chatGPT(content: String) {
        /// 이거 messages를 계속 쌓아야 할듯
        /// response 줄때도 Chat 타입으로 주니까 그냥 이걸 쌓아야할듯
        /// 그러면 대화내용을 기억하겠지?
        
        let chat = Chat(role: .user, content: content)
        chatStory.append(chat)
        
        layoutModel.tableViewUpdate()
        
        let query = ChatQuery(model: .gpt3_5Turbo, messages: self.chatStory,
                              maxTokens: 256,
                              presencePenalty: 0.6, frequencyPenalty: 0.6)
        
        openAI.chats(query: query) { [weak self] result in
            guard let self = self else { return }
            print("result: \(result)")
            
            switch result {
            case .success(let success):
                print("GPT: \(success.choices.map({$0.message}))")
                guard let chat = success.choices.first?.message else { return }
                self.chatStory.append(chat)
                let message = chat.content
                DispatchQueue.main.async {
                    self.layoutModel.tableViewUpdate()
                }
            case .failure(let failure):
                print("error: \(failure.localizedDescription)")
            }
        }
    }
    
    /// 일단 대충 만들게
    func bind() {
        layoutModel.chatInputBar.sendButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                print("눌림")
                guard let text = owner.layoutModel.chatInputBar.inputTextView.text,
                      !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                
                print("text: \(text)")
                
                owner.layoutModel.chatInputBar.clearInputView(true)
                owner.chatGPT(content: text)
            }).disposed(by: disposeBag)
    }

    func setDelegate() {
        layoutModel.tableView.dataSource = self
        layoutModel.tableView.delegate = self
    }
}

