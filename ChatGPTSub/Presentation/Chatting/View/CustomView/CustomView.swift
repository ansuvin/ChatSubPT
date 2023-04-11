//
//  CustomView.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/07.
//

import Foundation
import UIKit

import RxSwift

class CustomView: UIView {
    
    var disposeBag = DisposeBag()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("없어요")
    }
    
    func addComponents() {}
    func setConstraints() {}
    func binding() {}
    
    func initView() {
        addComponents()
        setConstraints()
        binding()
    }
}
