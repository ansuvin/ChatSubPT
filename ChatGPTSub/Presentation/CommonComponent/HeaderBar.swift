//
//  HeaderBar.swift
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

class HeaderBar: CustomView {
    var titleLabel = UILabel().then {
        $0.textColor = .gray20
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    var backBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .black
    }
    
    override func initView() {
        
        self.backgroundColor = .white
        self.layer.applySketchShadow(color: .warmGrey, alpha: 0.2, y: 3, blur: 4)
        
        addComponents()
        setConstraints()
    }
    
    override func addComponents() {
        [backBtn, titleLabel].forEach(self.addSubview(_:))
    }
    
    override func setConstraints() {
        backBtn.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.left.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(100)
            $0.trailing.lessThanOrEqualToSuperview().inset(100)
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
