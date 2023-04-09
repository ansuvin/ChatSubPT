//
//  MyCell.swift
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

class MyCell: UITableViewCell, CommonCell {
    
    var bgView = UIView().then {
        $0.backgroundColor = .primary200
        $0.layer.cornerRadius = 8
    }
    
    var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    var contentsLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
    }
    
    var loadingIndicator = LottieAnimationView(name: "yellow_dot_loading").then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.isHidden = true
    }
    
    var assistLabel = UILabel().then {
        $0.text = "메세지를 작성중"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .grayA4
        $0.isHidden = true
    }
    
    var timeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .grayA4
    }
    
    static var identifier = "MyCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        [bgView, timeLabel].forEach(self.contentView.addSubview(_:))
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
        
        timeLabel.snp.makeConstraints {
            $0.bottom.equalTo(bgView)
            $0.right.equalTo(bgView.snp.left).offset(-4)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.size.equalTo(17)
        }
    }
    
    func configCell(_ model: ChatItem) {
        contentsLabel.text = model.contents
        timeLabel.text = model.insDate.timeStr
        
        switch model.state {
        case .normal:
            setNomalState()
        case .writing:
            setWritingState()
        }
        
    }
    
    func setNomalState() {
        
    }
    
    func setWritingState() {
        contentsLabel.isHidden = true
        timeLabel.isHidden = true
        
        loadingIndicator.isHidden = false
        loadingIndicator.play()
        assistLabel.isHidden = false
        
    }
    
    override func prepareForReuse() {
        contentsLabel.text = ""
        
        contentsLabel.isHidden = false
        timeLabel.isHidden = false
        
        loadingIndicator.isHidden = true
        loadingIndicator.stop()
        assistLabel.isHidden = true
    }
}
