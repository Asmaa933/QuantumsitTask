//
//  ViewModel.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation
import RxSwift
import GoogleMaps

// MARK: - Loading states

public enum State {
    case loading
    case error
    case empty
    case populated
}

class ViewModel{
    
    // MARK: - Variables
    
    private var disposeBag = DisposeBag()
    private var supervisorData: Login?
    private let apiHandler : ApiHandlerProtocol = ApiHandler()
    private var loginObservable: Observable<BaseResponse<Login>>?
    private var aboutUsObservable: Observable<BaseResponse<[AboutUsModel]>>?
    
    var errorSubject: PublishSubject<String> = PublishSubject()
    var pathSubject: PublishSubject<[CLLocationCoordinate2D]> = PublishSubject()
    var pinsSubject: PublishSubject<[CLLocationCoordinate2D]> = PublishSubject()
    var contentSubject: PublishSubject<String> = PublishSubject()
    var updateLoadingStatus: (()->())?
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    // MARK: - Api
    
    func loginSupervisor() {
        state = .loading
        let loginData = ["name":"bola_d","password":"1234","deviceToken": ""]
          if ReachabilityManager.isConnectedToNetwork() {
            loginObservable = apiHandler.loginSupervisor(loginData: loginData)
            loginObservable?.subscribe {[weak self] (loginData) in
                guard let self = self else {return}
                self.supervisorData = loginData.innerData
                self.retrieveAllPaths()
                self.retrieveAllStopPoints()
                self.state = .populated
            } onError: { (error) in
                self.errorSubject.onNext(error.localizedDescription.description)
                self.state = .error
            }.disposed(by: disposeBag)
        }else {
            self.errorSubject.onNext(ErrorMessages.connectionError)
            self.state = .error
        }
    }
    
    func getAboutUs() {
        state = .loading
        if ReachabilityManager.isConnectedToNetwork() {
            aboutUsObservable = apiHandler.getAboutUs(token: supervisorData?.token ?? "")
            aboutUsObservable?.subscribe(onNext: {[weak self] (resultData) in
                guard let self = self else {return}
                self.contentSubject.onNext(resultData.innerData?[0].content ?? "")
                self.state = .populated
            }, onError: { (error) in
                self.errorSubject.onNext(error.localizedDescription.description)
                self.state = .error
            }).disposed(by: disposeBag)
        }else{
            self.errorSubject.onNext(ErrorMessages.connectionError)
            self.state = .error
        }
    }
}

// MARK: - Helper Methods

fileprivate extension ViewModel {
    
    func retrieveAllPaths() {
        guard let routePath = supervisorData?.routePath else {return}
        let coordinates = routePath.map({CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng)})
        self.pathSubject.onNext(coordinates)
    }
    
    func retrieveAllStopPoints() {
        guard let stopPoints = supervisorData?.stopPoints else {return}
        let pins = stopPoints.map({CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng)})
        self.pinsSubject.onNext(pins)
    }
}
