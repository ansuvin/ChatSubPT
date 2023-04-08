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
        viewModel._chatList
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.layoutModel.tableViewUpdate()
            }).disposed(by: disposeBag)
    }
}