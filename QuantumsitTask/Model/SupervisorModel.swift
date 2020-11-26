//
//  SupervisorModel.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation

//(user->bus->route->routePath) and (user->bus->route->stop_points)
struct Login: Codable {
    let token: String?
    let user: UserModel?
    
}

// MARK: - UserModel
struct UserModel: Codable {
    let hasBus: Bool?
    let bus: BusModel?

    enum CodingKeys: String, CodingKey {
        case hasBus = "HasBus"
        case bus
    }
}

struct BusModel: Codable {
    
    let route: Route?

    enum CodingKeys: String, CodingKey {
        case route
    }
}

// MARK: - Route
struct Route: Codable {
    let routePath: [Location]?
    let stopPoints: [Location]?

    enum CodingKeys: String, CodingKey {
        case routePath
        case stopPoints = "stop_points"
    }
}

struct Location: Codable {
    let lat, lng: Double
}



