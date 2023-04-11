//
//  CommonCell.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/08.
//

import Foundation

protocol CommonCell {
    static var identifier: String { get set }
    
    func initCell()
    
    func addComponents()
    func setConstraints()
    func bind()
}

extension CommonCell {
    func initCell() {
        addComponents()
        setConstraints()
        bind()
    }
    
    func bind() {
        
    }
}
