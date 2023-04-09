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
                
                viewModel.sendMsg(msg: owner.chatInputBar.inputTextView.text)
            }).disposed(by: disposeBag)
        
        chatInputBar.inputTextView.rx.didChange
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                viewModel.writingMsg(msg: owner.chatInputBar.inputTextView.text)
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
}
