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
        bindResendView(to: viewModel)
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
    
    func bindResendView(to viewModel: ChattingViewModel) {
        resendView.deleteButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.hideResendView()
            }).disposed(by: disposeBag)
        
        resendView.resendButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.hideResendView()
                viewModel.sendMsg(msg: owner.resendView.contentsText)
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
