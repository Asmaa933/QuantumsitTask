//
//  ApiHandler.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation

protocol ApiHandlerProtocol {
    func getAboutUs(token: String, completion: @escaping (Result<BaseResponse<[AboutUsModel]>?, NSError>) -> Void)
    func loginSupervisor(loginData: [String:String], completion: @escaping (Result<BaseResponse<Login>?, NSError>) -> Void)
    
}

class ApiHandler: BaseAPI<ApiNetworking>, ApiHandlerProtocol {
   
    func getAboutUs(token: String, completion: @escaping (Result<BaseResponse<[AboutUsModel]>?, NSError>) -> Void) {
        self.fetchData(target: .aboutUs(token: token), responseClass: BaseResponse<[AboutUsModel]>.self) { (response) in
            completion(response)
        }
    }
    
    func loginSupervisor(loginData: [String:String], completion: @escaping (Result<BaseResponse<Login>?, NSError>) -> Void) {
        self.fetchData(target: .loginSupervisor(loginData: loginData), responseClass: BaseResponse<Login>.self) { (response) in
            completion(response)
        }
    }

}
