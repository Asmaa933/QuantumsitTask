//
//  ApiNetworking.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation
import Alamofire

enum ApiNetworking {
    case aboutUs(token: String)
    case loginSupervisor(loginData: [String:String])
}

extension ApiNetworking: TargetType {
    var baseURL: String {
        return Constants.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .aboutUs:
            return "aboutus/aboutUs"
        case .loginSupervisor:
            return "account/checkCredentials"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .aboutUs:
            return .get
        case .loginSupervisor:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .aboutUs:
            return .requestPlain
        case .loginSupervisor(loginData: let loginData):
            return .requestParameters(parameters: loginData, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .aboutUs(token: let token):
            return ["Authorization": "Bearer \(token)"]
        case .loginSupervisor:
            return ["Content-Type":"application/json","Accept":"application/json"]
            
        }
    }
}
