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

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutModel.viewDidLoad(superView: self.view)
        
        self.view.backgroundColor = .white
        
        bind()
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
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [Chat(role: .user, content: content)],
                              maxTokens: 256,
                              presencePenalty: 0.6, frequencyPenalty: 0.6)
        
        openAI.chats(query: query) { [weak self] result in
            guard let self = self else { return }
            print("result: \(result)")
            
            switch result {
            case .success(let success):
                print("GPT: \(success.choices.map({$0.message}))")
                let message = success.choices.first?.message.content
                DispatchQueue.main.async {
                    self.layoutModel.gptLabel.text = message
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
                
                owner.layoutModel.myLabel.text = text
                owner.chatGPT(content: text)
            }).disposed(by: disposeBag)
    }

}

