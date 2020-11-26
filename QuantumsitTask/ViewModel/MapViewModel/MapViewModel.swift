//
//  MapViewModel.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation
import GoogleMaps

//{
//  "name":"bola_d",
//  "password":"1234",
//  "deviceToken": ""
//}

class MapViewModel: BaseViewModel{
    
    private var supervisorData: Login? {
        didSet{
            self.updateUIClosure?()
        }
    }
    
    var routes: [CLLocationCoordinate2D]? {
        didSet{
            
        }
    }
    
    func loginSupervisor() {
        state = .loading
        let loginData = ["name":"bola_d","password":"1234","deviceToken": ""]
        apiHandler.loginSupervisor(loginData: loginData) {[weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                if data?.status ?? false {
                    self.supervisorData = data?.innerData
                    self.state = .populated
                }else {
                    self.alertMessage = data?.message
                    self.state = .error
                }
                
            case .failure(let error):
                self.alertMessage = error.userInfo[NSLocalizedDescriptionKey] as? String
                self.state = .error
            }
        }
    }
    
    func makeRoutes() {
    }
    
    func getToken() -> String {
        return supervisorData?.token ?? ""
    }
    
    
}
