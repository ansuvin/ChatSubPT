//
//  SystemCell.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/08.
//

import Foundation
import UIKit

import Then
import SnapKit

import Lottie

import RxSwift

import OpenAI

class AssistantCell: UITableViewCell, CommonCell {
    
    var bgView = UIView().then {
        $0.backgroundColor = .primary300
        $0.layer.cornerRadius = 8
    }
    
    var stackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    var contentsLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
    }
    
    var loadingIndicator = LottieAnimationView(name: "yello_long_dot_loading").then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.isHidden = true
    }
    
    var assistLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .grayA4
        $0.isHidden = true
    }
    
    static var identifier = "AssistantCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        [bgView].forEach(self.contentView.addSubview(_:))
        [stackView].forEach(bgView.addSubview(_:))
        [contentsLabel, loadingIndicator, assistLabel].forEach(stackView.addArrangedSubview(_:))
    }
    
    func setConstraints() {
        bgView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.right.equalToSuperview().inset(12)
            $0.width.lessThanOrEqualToSuperview().offset(-100)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func configCell(_ model: Chat) {
        contentsLabel.text = model.content
        
        contentsLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        contentsLabel.text = ""
    }
}
