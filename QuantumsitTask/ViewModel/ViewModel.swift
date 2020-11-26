//
//  ViewModel.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps


public enum State {
    case loading
    case error
    case empty
    case populated
}

class ViewModel{
    
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
    
    
    func loginSupervisor() {
        state = .loading
        let loginData = ["name":"bola_d","password":"1234","deviceToken": ""]
        loginObservable = apiHandler.loginSupervisor(loginData: loginData)
        loginObservable?.subscribe { (loginData) in
            self.supervisorData = loginData.innerData
            self.retrieveAllPaths()
            self.retrieveAllStopPoints()
            self.state = .populated
        } onError: { (error) in
            self.state = .error
            self.errorSubject.onNext(error.localizedDescription.description)
        }.disposed(by: disposeBag)
    }
    
    func getAboutUs() {
        state = .loading
        aboutUsObservable = apiHandler.getAboutUs(token: supervisorData?.token ?? "")
        aboutUsObservable?.subscribe(onNext: { (resultData) in
            self.contentSubject.onNext(resultData.innerData?[0].content ?? "")
            self.state = .populated
        }, onError: { (error) in
            self.state = .error
            self.errorSubject.onNext(error.localizedDescription.description)
        }).disposed(by: disposeBag)
       
    }
    
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
