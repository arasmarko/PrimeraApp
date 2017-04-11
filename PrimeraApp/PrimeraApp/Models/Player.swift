//
//  Player.swift
//  PrimeraApp
//
//  Created by Marko Aras on 11/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import SwiftyJSON

class Player {
    let name: String
    let position: String
    let jerseyNumber: Int
    let dateOfBirth: String
    let nationality: String
    let contractUntil: String
    let marketValue: String
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.position = json["position"].stringValue
        self.jerseyNumber = json["jerseyNumber"].intValue
        self.dateOfBirth = json["dateOfBirth"].stringValue
        self.nationality = json["nationality"].stringValue
        self.contractUntil = json["contractUntil"].stringValue
        self.marketValue = json["marketValue"].stringValue
    }}
