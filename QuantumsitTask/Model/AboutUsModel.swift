//
//  AboutUsModel.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation

struct AboutUsModel: Codable {
    let id: Int?
    let content: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

