//
//  UINavigationExetensions.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/11.
//

import Foundation
import UIKit

extension UINavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    static func defauleNavigation() -> UINavigationController{
        let navigation = UINavigationController()
            navigation.hidesBottomBarWhenPushed = true
            navigation.setToolbarHidden(true, animated: false)
            navigation.setNavigationBarHidden(true, animated: false)
        return navigation
    }
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK :  Navigation Stack에 쌓인 뷰가 1개를 초과해야 제스처가 동작 하도록
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return viewControllers.count > 1
    }
}
