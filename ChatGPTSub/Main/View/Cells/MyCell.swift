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
    
    var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
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
    
    var loadingIndicatorContainer = UIView().then { $0.isHidden = true }
    var loadingIndicator = LottieAnimationView(name: "yellow_dot_loading").then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
    }
    
    var assistLabel = UILabel().then {
        $0.text = "메세지를 작성중"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .grayA4
        $0.isHidden = true
    }
    
    var errorTitleContainerView = UIView().then {
        $0.isHidden = true
    }
    var errorIcon = UIImageView().then {
        $0.image = UIImage(systemName: "exclamationmark.circle")
        $0.tintColor = .red
    }
    
    var errorLabel = UILabel().then {
        $0.text = "답변 받지 못한 메세지"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray20
    }
    
    var lineView = UIView().then {
        $0.backgroundColor = .gray90
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
        [containerStackView].forEach(bgView.addSubview(_:))
        
        [stackView, lineView, errorTitleContainerView].forEach(containerStackView.addArrangedSubview(_:))
        
        [errorIcon, errorLabel].forEach(errorTitleContainerView.addSubview(_:))
        [contentsLabel, loadingIndicatorContainer, assistLabel].forEach(stackView.addArrangedSubview(_:))
        
        [loadingIndicator].forEach(loadingIndicatorContainer.addSubview(_:))
    }
    
    func setConstraints() {
        bgView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.right.equalToSuperview().inset(12)
            $0.width.lessThanOrEqualToSuperview().offset(-100)
        }
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.bottom.equalTo(bgView)
            $0.right.equalTo(bgView.snp.left).offset(-4)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.size.equalTo(17)
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
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
        case .error:
            setErrorState()
        default:
            print("none")
        }
        
    }
    
    func setNomalState() {
        
    }
    
    func setWritingState() {
        contentsLabel.isHidden = true
        timeLabel.isHidden = true
        
        loadingIndicatorContainer.isHidden = false
        loadingIndicator.play()
        assistLabel.isHidden = false
        
    }
    
    func setErrorState() {
        errorTitleContainerView.isHidden = false
        lineView.isHidden = false
        
        errorIcon.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.top.left.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints {
            $0.left.equalTo(errorIcon.snp.right).offset(2)
            $0.top.bottom.equalToSuperview()
            $0.right.lessThanOrEqualToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
    
    override func prepareForReuse() {
        contentsLabel.text = ""
        
        contentsLabel.isHidden = false
        timeLabel.isHidden = false
        
        loadingIndicatorContainer.isHidden = true
        loadingIndicator.stop()
        assistLabel.isHidden = true
        
        errorTitleContainerView.isHidden = true
        lineView.isHidden = true
        errorIcon.snp.removeConstraints()
        errorLabel.snp.removeConstraints()
        lineView.snp.removeConstraints()
    }
}
