//
//  ResendView.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/09.
//

import Foundation
import UIKit

import Then
import SnapKit

import RxSwift

class ResendView: CustomView {
    
    var bgView = UIView().then {
        $0.backgroundColor = .primary400
        $0.layer.cornerRadius = 10
        $0.layer.applySketchShadow(alpha: 0.3, blur: 6)
    }
    
    var containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    var labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
    }
    
    var errorTitleContainerView = UIView()
    var errorIcon = UIImageView().then {
        $0.image = UIImage(systemName: "exclamationmark.circle")
        $0.tintColor = .red
    }
    
    var errorLabel = UILabel().then {
        $0.text = "답변 오류"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray20
    }
    
    var descriptionLabel = UILabel().then {
        $0.text = "다시 보내시겠습니까?"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray20
    }
    
    var lineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    var contentsLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray50
        $0.text = "예시 텍스트 예시 텍스트 슈슉 슈슉 이건 예시 텍스트예시 텍스트 예시 텍스트 슈슉 슈슉 이건 예시 텍스트예시 텍스트 예시 텍스트 슈슉 슈슉 이건 예시 텍스트예시 텍스트 예시 텍스트 슈슉 슈슉 이건 예시 텍스트"
    }
    
    var deleteContainerView = UIView()
    var deleteButton = UIButton().then {
        $0.setBackgroundImage(UIImage(systemName: "trash.circle"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
    }
    
    var resendContainerView = UIView()
    var resendButton = UIButton().then {
        $0.setBackgroundImage(UIImage(systemName: "paperplane.circle"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
    }
    
    var contentsText: String?
    
    override func addComponents() {
        [bgView].forEach(self.addSubview(_:))
        
        [containerStackView].forEach(bgView.addSubview(_:))
        [labelStackView, deleteContainerView, resendContainerView].forEach(containerStackView.addArrangedSubview(_:))
        
        [errorTitleContainerView, lineView, contentsLabel].forEach(labelStackView.addArrangedSubview(_:))
        
        [errorIcon, errorLabel, descriptionLabel].forEach(errorTitleContainerView.addSubview(_:))
        
        [deleteButton].forEach(deleteContainerView.addSubview(_:))
        [resendButton].forEach(resendContainerView.addSubview(_:))
    }
    
    override func setConstraints() {
        bgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        labelStackView.snp.makeConstraints {
            $0.width.equalTo(220)
        }
        
        errorIcon.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.top.left.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints {
            $0.left.equalTo(errorIcon.snp.right).offset(2)
            $0.centerY.equalTo(errorIcon)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(errorLabel.snp.bottom).offset(2)
            $0.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        deleteButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        resendButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func setContents(_ text: String) {
        contentsLabel.text = text
        contentsText = text
    }
}
