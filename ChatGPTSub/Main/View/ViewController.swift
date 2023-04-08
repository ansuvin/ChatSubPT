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
    
    var layoutModel: ChattingLayout!
    var viewModel: ChattingViewModel!
    
    var disposeBag = DisposeBag()
    
    static func create() -> ViewController {
        let vc = ViewController()
        vc.layoutModel = ChattingLayout()
        vc.viewModel = DefaultChattingViewModel()
        
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        layoutModel.viewDidLoad(superView: self.view)
        viewModel.viewDidLoad()
        
        
        bind()
        setDelegate()
    }
    
    /// 일단 대충 만들게
    func bind() {
        viewModel._chatList
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.layoutModel.tableViewUpdate()
            }).disposed(by: disposeBag)
        
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
                owner.viewModel.sendMsg(msg: text)
            }).disposed(by: disposeBag)
    }

    func setDelegate() {
        layoutModel.tableView.dataSource = self
        layoutModel.tableView.delegate = self
    }
}

