//
//  TargetType.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation
import Alamofire

// MARK:- HTTPMethod

enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
}

// MARK:- Task

enum Task {
    case requestPlain
    case requestParameters(parameters: [String: Any],encoding: ParameterEncoding)
}

// MARK:- TargetType

protocol TargetType {
    var baseURL: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var task: Task {get}
    var headers: [String:String]? {get}
}
