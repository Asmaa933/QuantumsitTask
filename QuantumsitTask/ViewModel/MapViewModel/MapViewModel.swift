//
//  MapViewModel.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps


protocol MapViewModelProtocol {
    var  pathDriver: Driver<[CLLocationCoordinate2D]> {set get}
    var  pinsDriver: Driver<[CLLocationCoordinate2D]> {set get}
    func loginSupervisor()
}

class MapViewModel: BaseViewModel, MapViewModelProtocol{
    
    var pathDriver: Driver<[CLLocationCoordinate2D]>
    var pinsDriver: Driver<[CLLocationCoordinate2D]>
    
    
    private var pathSubject: PublishSubject<[CLLocationCoordinate2D]> = PublishSubject()
    private var pinsSubject: PublishSubject<[CLLocationCoordinate2D]> = PublishSubject()
    private var supervisorData: Login?
    
    
    override init() {
        pathDriver = pathSubject.asDriver(onErrorJustReturn: [])
        pinsDriver = pinsSubject.asDriver(onErrorJustReturn: [])
        super.init()
    }
    
    func loginSupervisor() {
        state = .loading
        let loginData = ["name":"bola_d","password":"1234","deviceToken": ""]
        apiHandler.loginSupervisor(loginData: loginData) {[weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                if data?.status ?? false && data?.innerData != nil {
                    self.supervisorData = data?.innerData
                    self.retrieveAllPaths()
                    self.retrieveAllStopPoints()
                    self.state = .populated
                }else {
                    self.errorSubject.onNext(data?.message ?? "")
                    self.state = .error
                }
                
            case .failure(let error):
                self.errorSubject.onNext(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
            }
        }
    }
    
    func retrieveAllPaths() {
        guard let routePath = supervisorData?.user?.bus?.route?.routePath else {return}
        let coordinates = routePath.map({CLLocationCoordinate2D(latitude: $0.lat ?? 0, longitude: $0.lng ?? 0)})
        self.pathSubject.onNext(coordinates)
    }
    
    func retrieveAllStopPoints() {
        guard let stopPoints = supervisorData?.user?.bus?.route?.stopPoints else {return}
        let pins = stopPoints.map({CLLocationCoordinate2D(latitude: $0.lat ?? 0, longitude: $0.lng ?? 0)})
        self.pinsSubject.onNext(pins)
    }
    
    func getToken() -> String {
        return supervisorData?.token ?? ""
    }
    
    
}
