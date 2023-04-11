//
//  ViewController.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/07.
//

import UIKit

import Then
import SnapKit
import PinLayout

import OpenAI

import RxSwift

class ViewController: UIViewController {
    
    var layoutModel: ChattingLayout!
    var viewModel: ChattingViewModel!
    
    var disposeBag = DisposeBag()
    
    static func create() -> ViewController {
        let vc = ViewController()
        vc.layoutModel = ChattingLayout()
        vc.viewModel = DefaultChattingViewModel()
        
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
        layoutModel.tableView.dataSource = self
        layoutModel.tableView.delegate = self
    }
}

