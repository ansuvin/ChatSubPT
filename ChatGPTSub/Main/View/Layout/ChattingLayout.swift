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
    
    var tableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 50
        $0.separatorStyle = .none
        
        $0.register(MyCell.self, forCellReuseIdentifier: MyCell.identifier)
        $0.register(AssistantCell.self, forCellReuseIdentifier: AssistantCell.identifier)
    }
    
    var chatInputBar = ChatInputBarView()
    
    var keyboardPopState = false
    
    var disposeBag = DisposeBag()
    
    func viewDidLoad(superView: UIView) {
        addComponents(superView)
        setConstraints(superView)
        addNotification()
    }
    
    func addComponents(_ superView: UIView) {
        superView.addSubview(layout)
        
        [tableView, chatInputBar].forEach(layout.addSubview(_:))
    }
    
    func setConstraints(_ superView: UIView) {
        layout.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIApplication.shared.windows.first?.safeAreaInsets ?? .zero)
        }

        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalTo(chatInputBar.snp.top)
        }

        chatInputBar.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
        }
    }
    
    func setDelegate() {
        
    }
    
    func tableViewUpdate() {
        tableView.reloadData()
    }

}
