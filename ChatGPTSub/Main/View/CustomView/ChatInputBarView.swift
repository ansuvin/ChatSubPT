//
//  ChatInputBarView.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/07.
//

import Foundation
import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

class ChatInputBarView: CustomView {
    let stackViewContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .bottom
        $0.distribution = .fill
    }
    
    let addButtonView = UIView()
    let addButtonImageView = UIImageView().then {
        $0.image = UIImage(systemName: "plus.app")
    }
    
    let textViewEmptyView = UIView()
    
    let textViewContainer = UIView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(white: 242/255, alpha: 1)
    }
    
    let inputTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .black
        $0.textContainerInset = .zero
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    let emptyView = UIView()
    
    let sendButtonView = UIView()
    let sendButtonImageView = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.up.circle.fill")
    }
    
    var placeHolderText = ""
    
    override func initView() {
        
        self.backgroundColor = .white
        addComponents()
        setConstraints()
        binding()
        
        inputTextView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func addComponents() {
        [stackViewContainer].forEach{ self.addSubview($0)}
        
        [
            addButtonView,
            textViewEmptyView,
            emptyView,
            sendButtonView
        ].forEach{ stackViewContainer.addArrangedSubview($0)}
        
        addButtonView.addSubview(addButtonImageView)
        sendButtonView.addSubview(sendButtonImageView)
        
        textViewEmptyView.addSubview(textViewContainer)
        textViewContainer.addSubview(inputTextView)
        
        setPlaceHolder()
    }
    
    override func setConstraints() {
        stackViewContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(6)
        }
        
        addButtonImageView.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.center.equalToSuperview()
        }
        
        addButtonView.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        
        textViewContainer.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0))
        }
        
        inputTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 9, left: 12, bottom: 10, right: 12))
            $0.height.equalTo(18)
        }
        
        emptyView.snp.makeConstraints {
            $0.width.equalTo(8)
        }
        
        sendButtonImageView.snp.makeConstraints {
            $0.width.height.equalTo(26)
            $0.center.equalToSuperview()
        }
        
        sendButtonView.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        
    }
    
    override func binding() {
        
        inputTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count == 1000 {
//                    self.toast?.hideAlltoast()
//                    Toast.smShow("메세지는 1000자까지만 작성 가능합니다.")
                }
            })
            .disposed(by: disposeBag)
        
        inputTextView.rx.didEndEditing
            .map{ [weak self] in self?.inputTextView}
            .filter{ $0 != nil}
            .subscribe(onNext:{ [weak self] textView in
                guard let self = self else { return }
                self.setNoneFocus()
            })
            .disposed(by: disposeBag)
        
        inputTextView.rx.didChange
            .map{ [weak self] in self?.inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)}
            .bind { [weak self] text in
                guard let self = self else { return }
                self.setInputViewOffset()
                self.setSendButtonEnable()
            }
            .disposed(by: disposeBag)
    }
    
    func clearInputView(_ keyboardPopState: Bool) {
        if self.inputTextView.text != "Enter message"{
            if keyboardPopState {
                inputTextView.text = ""
                sendButtonImageView.tintColor = .black
            } else {
                setPlaceHolder()
            }
        }
        self.setInputViewOffset()
    }

}

extension ChatInputBarView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.setFocus()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let currentText = textView.text else { return false }
        guard let stringRange = Range(range, in : currentText) else { return false}
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count < 1001
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.setInputViewOffset()
    }
    
    func setInputViewOffset() {
        let size = inputTextView.bounds.size
        let newSize = inputTextView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height < 60 {
            inputTextView.isScrollEnabled = false
            if size.height != newSize.height {
                self.inputTextView.snp.updateConstraints {
                    $0.height.equalTo(newSize.height)
                }
            }
        } else {
            inputTextView.isScrollEnabled = true
            self.inputTextView.snp.updateConstraints {
                $0.height.equalTo(72)
            }
        }
    }
    
    func setSendButtonEnable() {
        if inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || inputTextView.text == placeHolderText {
            sendButtonView.isUserInteractionEnabled = false
            sendButtonImageView.tintColor = .black
        } else {
            sendButtonView.isUserInteractionEnabled = true
            sendButtonImageView.tintColor = .blue
        }
    }
    
    /// 플레이스 홀더: 적힌 글이 없을 때
    func setPlaceHolder() {
        placeHolderText = "Enter message"
        inputTextView.text = placeHolderText
        inputTextView.textColor = .darkGray
        textViewContainer.backgroundColor = UIColor(white: 242/255, alpha: 1)
        textViewContainer.layer.borderWidth = 0
        inputTextView.isEditable = true
        inputTextView.isSelectable = true
        addButtonView.isUserInteractionEnabled = true
        sendButtonView.isUserInteractionEnabled = true
        sendButtonImageView.tintColor = .black
    }
    
    func endEditing() {
        self.inputTextView.endEditing(true)
    }
    
    /// 포커스: 텍스트뷰에 포커스 되어 있을 때, 내용이 입력되어있을때 유지
    func setFocus() {
        if let inputText = inputTextView.text, inputText == placeHolderText {
            inputTextView.text = ""
        }
        inputTextView.textColor = .black
        textViewContainer.layer.borderColor = UIColor.black.cgColor
        textViewContainer.layer.borderWidth = 1
        
        if !inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sendButtonImageView.tintColor = .blue
        }
    }
    
    func setNoneFocus() {
        if inputTextView.text.count == 0 {
            self.setPlaceHolder()
        }
    }
    
    /// 비활성화: 대화 종료, 탈퇴한 회원
    /// 따로 인자값을 받을까 생각중 탈퇴한건지 대화 종료된건지
    func setDisable(_ msg: String) {
        placeHolderText = msg
        
        inputTextView.text = msg
        inputTextView.textColor = .gray
        
        textViewContainer.layer.borderWidth = 0
        textViewContainer.backgroundColor = .darkGray
        
        inputTextView.isEditable = false
        inputTextView.isSelectable = false
        
        addButtonView.isUserInteractionEnabled = false
        addButtonImageView.tintColor = .black
        
        sendButtonView.isUserInteractionEnabled = false
        sendButtonImageView.tintColor = .blue
    }
}
