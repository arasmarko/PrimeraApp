//
//  PrimeraAPI.swift
//  PrimeraApp
//
//  Created by Marko Aras on 22/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import Moya
import CoreLocation

enum PrimeraAPI {
    case primera
    case teams
}
// MARK: - TargetType Protocol Implementation
extension PrimeraAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://api.football-data.org/v1")!
    }
    var path: String {
        switch self {
        case .primera:
            return "/competitions/436"
        case .teams:
            return "/competitions/436/teams"
        }
    }
    var method: Moya.Method {
        switch self {
        case .primera, .teams:
            return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .primera, .teams:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default // Send parameters in URL
    }
    
    public var sampleData: Data {
        fatalError("Not implemented yet")
    }
    
    var task: Task {
        switch self {
        case .primera, .teams:
            return .request
        }
    }
    
}