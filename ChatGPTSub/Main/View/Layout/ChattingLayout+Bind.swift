//
//  ChattingLayout+Bind.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/08.
//

import Foundation
import UIKit

import RxSwift

extension ChattingLayout {
    func bind(to viewModel: ChattingViewModel) {
        bindChatInputBarView(to: viewModel)
        extraBind()
    }
    
    func bindChatInputBarView(to viewModel: ChattingViewModel) {
        chatInputBar.sendButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                print("눌림")
                guard let text = owner.isValidInputText() else { return }
                
                owner.chatInputBar.clearInputView(owner.keyboardPopState)
                viewModel.sendMsg(msg: text)
            }).disposed(by: disposeBag)
    }
    
    func extraBind() {
        tableView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.chatInputBar.endEditing()
            }).disposed(by: disposeBag)
    }
    
    
    func isValidInputText() -> String? {
        guard let text = chatInputBar.inputTextView.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              text != chatInputBar.placeHolderText else {
            return nil
        }
        
        print("validText: \(text)")
        return text
    }
}
