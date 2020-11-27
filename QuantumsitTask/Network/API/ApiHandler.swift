//
//  ApiHandler.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation
import RxSwift

// MARK:- ApiHandlerProtocol

protocol ApiHandlerProtocol {
    func getAboutUs(token: String) -> Observable<BaseResponse<[AboutUsModel]>>
    func loginSupervisor(loginData: [String:String]) -> Observable<BaseResponse<Login>>
}

// MARK:- ApiHandler

class ApiHandler: BaseAPI<ApiNetworking>, ApiHandlerProtocol {
    
    func getAboutUs(token: String) -> Observable<BaseResponse<[AboutUsModel]>> {
        return self.fetchData(target: .aboutUs(token: token), responseClass: BaseResponse<[AboutUsModel]>.self)
    }
    
    func loginSupervisor(loginData: [String:String]) -> Observable<BaseResponse<Login>> {
        return self.fetchData(target: .loginSupervisor(loginData: loginData), responseClass: BaseResponse<Login>.self)
    }
}

