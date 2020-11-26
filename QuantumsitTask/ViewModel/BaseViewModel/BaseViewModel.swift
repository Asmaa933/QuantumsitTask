//
//  BaseViewModel.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation

public enum State {
    case loading
    case error
    case empty
    case populated
}

class BaseViewModel {
    
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
