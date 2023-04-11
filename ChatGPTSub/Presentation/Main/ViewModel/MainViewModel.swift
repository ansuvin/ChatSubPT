//
//  MainViewModel.swift
//  ChatGPTSub
//
//  Created by yeoboya on 2023/04/11.
//

import Foundation

import RxSwift

protocol MainViewModelInput {
    func viewDidLoad()
    func moveChat()
}

protocol MainViewModelOutput {
    var _moveChat: PublishSubject<Void> { get set }
}

protocol MainViewModel: ViewModelProtocol, MainViewModelInput, MainViewModelOutput {
    
}

class DefaultMainViewModel: MainViewModel {
    var disposeBag = DisposeBag()
    
    var _moveChat: PublishSubject<Void> = .init()
    
    func viewDidLoad() {
        
    }
   
    func moveChat() {
        _moveChat.onNext(())
    }
}
