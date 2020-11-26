//
//  ApiHandler.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation

protocol ApiHandlerProtocol {
    func getAboutUs(completion: @escaping (Result<BaseResponse<[AboutUsModel]>?, NSError>) -> Void)
}

class ApiHandler: BaseAPI<ApiNetworking>, ApiHandlerProtocol {
    func getAboutUs(completion: @escaping (Result<BaseResponse<[AboutUsModel]>?, NSError>) -> Void) {
        self.fetchData(target: .aboutUs, responseClass: BaseResponse<[AboutUsModel]>.self) { (response) in
            completion(response)
        }
    }
}
