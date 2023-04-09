//
//  ChattingLayout+Keyboard.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/07.
//

import Foundation
import UIKit

extension ChattingLayout {
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo = sender.userInfo!
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let keyboardAnimationOptions = UIView.AnimationOptions(rawValue: curve << 16)
        let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: keyboardAnimationOptions) {
                let constant = keyboardSize.height - self.layout.safeAreaInsets.bottom
                
                self.chatInputBar.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(constant)
                }
                
                self.layout.layoutIfNeeded()
            }
        }
        
        self.keyboardPopState = true
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.chatInputBar.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(0)
            }
            
            self.layout.layoutIfNeeded()
        }
        
        self.keyboardPopState = false
    }
}
