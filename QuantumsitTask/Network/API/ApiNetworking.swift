//
//  ApiNetworking.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation

enum ApiNetworking {
    case aboutUs
}

extension ApiNetworking: TargetType {
    var baseURL: String {
        switch self {
        case .aboutUs:
            return Constants.apiBaseURL
        }
    }
    
    var path: String {
        switch self {
        case .aboutUs:
            return "aboutus/aboutUs"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .aboutUs:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .aboutUs:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .aboutUs:
            return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjI0NywiaXNzIjoiaHR0cDovL2luYWNsaWNrLm9ubGluZS9tdGMvYWNjb3VudC9jaGVja0NyZWRlbnRpYWxzIiwiaWF0IjoxNjA2MzU3OTM5LCJleHAiOjE2MDY0NDQzMzksIm5iZiI6MTYwNjM1NzkzOSwianRpIjoiSzN5bTVVRFNnU29Kc2JycSJ9.5EEG8oP16tEsgpun5YK0G5ViARW0msFdDo4tdZK1FYw"]
        }
    }
}
