//
//  BaseResponse.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation

// MARK:- BaseResponse
struct BaseResponse<T: Codable>: Codable {
    var message: String?
    var status: Bool?
    var innerData: T?
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
        case innerData = "InnerData"
    }
}
