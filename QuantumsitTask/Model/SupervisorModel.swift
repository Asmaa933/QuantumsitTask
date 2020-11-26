//
//  SupervisorModel.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation

//(user->bus->route->routePath) and (user->bus->route->stop_points)
struct Login: Codable {
    var token: String = ""
    var routePath: [Location] = [Location]()
    var stopPoints: [Location] = [Location]()
    
    enum LoginKeys: String, CodingKey {
        case token
        case user
    }
    
    enum UserKeys: String, CodingKey {
        case bus
    }
    enum BusKeys: String, CodingKey {
        case route
    }
    enum RouteKeys: String, CodingKey {
        case routePath
        case stopPoints = "stop_points"
    }
    
    init(from decoder: Decoder) throws {
        guard let mainContainer = try? decoder.container(keyedBy: LoginKeys.self) else {return}
        self.token = try mainContainer.decode(String.self, forKey: .token)
        guard let userContainer = try? mainContainer.nestedContainer(keyedBy: UserKeys.self, forKey: .user) else {return}
        guard let busContainer = try? userContainer.nestedContainer(keyedBy: BusKeys.self, forKey: .bus) else {return}
        guard let routeContainer = try? busContainer.nestedContainer(keyedBy: RouteKeys.self, forKey: .route) else {return}
        
        self.routePath = try routeContainer.decode([Location].self, forKey: .routePath)
        self.stopPoints = try routeContainer.decode([Location].self, forKey: .stopPoints)
        
    }
}

struct Location: Codable {
    let lat, lng: Double
}



