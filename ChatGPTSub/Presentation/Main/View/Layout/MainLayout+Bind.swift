//
//  MainLayout+Bind.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/11.
//

import Foundation

import RxSwift
import RxCocoa
import RxGesture

extension MainLayout {
    func bind(to viewModel: MainViewModel) {
        moveChatBtn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                viewModel.moveChat()
            }).disposed(by: disposeBag)
    }
}
