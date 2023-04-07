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
import FlexLayout

import OpenAI

class ViewController: UIViewController {
    
    let openAI = OpenAI(apiToken: "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")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        self.view.backgroundColor = .white
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
    
    func chatGPT() {
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [Chat(role: "user", content: "4월에 제주도 가고싶은데 언제 가는게 좋을까?")],
                              maxTokens: 256,
                              presencePenalty: 0.6, frequencyPenalty: 0.6)
        
        openAI.chats(query: query) { result in
            print("result: \(result)")
            
            switch result {
            case .success(let success):
                print("GPT: \(success.choices.map({$0.message}))")
            case .failure(let failure):
                print("error")
            }
        }
    }

}

