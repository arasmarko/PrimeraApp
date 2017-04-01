//
//  Team.swift
//  PrimeraApp
//
//  Created by Marko Aras on 22/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import SwiftyJSON

class Team {
    let name: String
    let shortName: String
    let crestUrl: String
    let squadMarketValue: String
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.shortName = json["shortName"].stringValue
        self.crestUrl = json["crestUrl"].stringValue
        self.squadMarketValue = json["squadMarketValue"].stringValue
        
    }
    
}
