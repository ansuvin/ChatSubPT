//
//  ChattingLayout.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/07.
//

import Foundation
import UIKit

import Then
import SnapKit
import PinLayout

import RxSwift
import RxCocoa
import RxGesture

class ChattingLayout: NSObject {
    var layout: UIView = UIView(frame: .zero).then {
        $0.backgroundColor = .white
    }
    
    var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    var myContainerView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .primary200
    }
    
    var gptContainerView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .primary200
    }
    
    var myLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.text = "MyLabel:..."
    }
    
    var gptLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .right
        $0.text = "GPTLabel:..."
    }
    
    var emptyView = UIView()
    
    var chatInputBar = ChatInputBarView()
    
    var disposeBag = DisposeBag()
    
    func viewDidLoad(superView: UIView) {
        addComponents(superView)
        setConstraints(superView)
        addNotification()
        binding()
    }
    
    func addComponents(_ superView: UIView) {
        superView.addSubview(layout)
        
        [stackView, chatInputBar].forEach(layout.addSubview(_:))
        
        [myContainerView, gptContainerView, emptyView].forEach(stackView.addArrangedSubview(_:))
        
        [myLabel].forEach(myContainerView.addSubview(_:))
        [gptLabel].forEach(gptContainerView.addSubview(_:))
    }
    
    func setConstraints(_ superView: UIView) {
        layout.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIApplication.shared.windows.first?.safeAreaInsets ?? .zero)
        }

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalTo(chatInputBar.snp.top)
        }

        chatInputBar.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
        }

        myLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }

        gptLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func setDelegate() {
        
    }
    
    func binding() {
        stackView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.chatInputBar.endEditing()
            }).disposed(by: disposeBag)
    }
}
