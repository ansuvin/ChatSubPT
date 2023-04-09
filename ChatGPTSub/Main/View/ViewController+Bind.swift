//
//  ViewController+Bind.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/08.
//

import Foundation

import RxSwift

extension ViewController {
    func bind(to viewModel: ChattingViewModel) {
        viewModel._updateChatItemList
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.layoutModel.tableViewUpdate()
            }).disposed(by: disposeBag)
        
        viewModel._clearInputBar
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.layoutModel.clearInputBar()
            }).disposed(by: disposeBag)
        
        viewModel._scrollToBottom
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, animated in
                owner.scrollToBottom(animated)
            }).disposed(by: disposeBag)
        
        viewModel._showResendView
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, text in
                owner.layoutModel.tableViewUpdate()
                owner.layoutModel.showResendView(conetents: text)
            }).disposed(by: disposeBag)
    }
}
