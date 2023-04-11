//
//  MainLayout.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/11.
//

import Foundation
import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa
import RxGesture

class MainLayout: NSObject {
    var layout: UIView = UIView(frame: .zero).then {
        $0.backgroundColor = .white
    }
    
    var moveChatBtn = UIButton().then {
        $0.setTitle("Move Chat!", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
    }
    
    var disposeBag = DisposeBag()
    
    func viewDidLoad(superView: UIView) {
        addComponents(superView)
        setConstraints(superView)
    }
    
    func addComponents(_ superView: UIView) {
        superView.addSubview(layout)
        
        [moveChatBtn].forEach(layout.addSubview(_:))
    }
    
    func setConstraints(_ superView: UIView) {
        layout.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        moveChatBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    func setDelegate() {
        
    }

}
