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
    
    var headerBar = HeaderBar().then {
        $0.setTitle("채팅창!")
    }
    
    var tableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 50
        $0.separatorStyle = .none
        
        $0.register(MyCell.self, forCellReuseIdentifier: MyCell.identifier)
        $0.register(AssistantCell.self, forCellReuseIdentifier: AssistantCell.identifier)
    }
    
    var chatInputBar = ChatInputBarView()
    
    var resendView = ResendView().then {
        $0.isHidden = true
        $0.alpha = 0
    }
    
    var keyboardPopState = false
    
    var disposeBag = DisposeBag()
    
    func viewDidLoad(superView: UIView) {
        addComponents(superView)
        setConstraints(superView)
        addNotification()
    }
    
    func addComponents(_ superView: UIView) {
        superView.addSubview(layout)
        
        [tableView, headerBar, chatInputBar, resendView].forEach(layout.addSubview(_:))
    }
    
    func setConstraints(_ superView: UIView) {
        layout.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIApplication.shared.windows.first?.safeAreaInsets ?? .zero)
        }
        
        headerBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(headerBar.snp.bottom)
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalTo(chatInputBar.snp.top)
        }

        chatInputBar.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
        }
        
        resendView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setDelegate() {
        
    }
    
    func tableViewUpdate() {
        tableView.reloadData()
    }
    
    func showResendView(conetents text: String) {
        resendView.setContents(text)
        resendView.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.hideResendView()
        }
    }
    
    func hideResendView() {
        resendView.hide()
    }

}
