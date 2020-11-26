//
//  BaseViewModel.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation
import RxSwift
import RxCocoa

public enum State {
    case loading
    case error
    case empty
    case populated
}

protocol BaseProtocol {
    var  errorDriver: Driver<String> {set get}
}

class BaseViewModel: BaseProtocol {
    
    var errorDriver: Driver<String>
    var errorSubject: PublishSubject<String> = PublishSubject()
    let apiHandler : ApiHandlerProtocol = ApiHandler()
    
    init() {
        errorDriver = errorSubject.asDriver(onErrorJustReturn: "")
    }
    
    
    

    var updateUIClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
}
