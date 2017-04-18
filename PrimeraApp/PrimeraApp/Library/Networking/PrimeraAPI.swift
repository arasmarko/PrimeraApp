//
//  PrimeraAPI.swift
//  PrimeraApp
//
//  Created by Marko Aras on 22/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//  X-Auth-Token: 903a40fb1e37410b8ea57c02f454584a

import Foundation
import Moya
import CoreLocation


enum PrimeraAPI {
    case primera
    case teams
    case table
    case fixtures
    case team(teamUrl: String)
    case players(playersUrl: String)
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
        case .table:
            return "/competitions/436/leagueTable"
        case .team(let url):
            return url
        case .players(let url):
            return url
        case .fixtures:
            return "/competitions/436/fixtures"
        }
    }
    var method: Moya.Method {
        switch self {
        case .primera, .teams, .team, .players, .table, .fixtures:
            return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .primera, .teams, .team, .players, .table, .fixtures:
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
        case .primera, .teams, .team, .players, .table, .fixtures:
            return .request
        }
    }
    
}
