//
//  MainViewController.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/11.
//

import Foundation
import UIKit

import Then
import SnapKit

import RxSwift

class MainViewController: UIViewController {
    
    var layoutModel: MainLayout!
    var viewModel: MainViewModel!
    
    var disposeBag = DisposeBag()
    
    static func create() -> MainViewController {
        let vc = MainViewController()
        vc.layoutModel = MainLayout()
        vc.viewModel = DefaultMainViewModel()
        
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        // setDelegate ->  LayoutModel -> ViewController -> ViewMode 순서로 bind
        setDelegate()
        layoutModel.viewDidLoad(superView: self.view)
        layoutModel.bind(to: viewModel)
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    func setDelegate() {
        
    }
    
    func bind(to viewModel: MainViewModel) {
        viewModel._moveChat
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.moveChat()
            }).disposed(by: disposeBag)
    }
    
    func moveChat() {
        let chatVC = ViewController.create()
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

