//
//  UIViewExetensions.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/09.
//

import Foundation
import UIKit

extension UIView {
    
    func show() {
        self.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
        }
    }
}
