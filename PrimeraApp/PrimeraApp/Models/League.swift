//
//  League.swift
//  PrimeraApp
//
//  Created by Marko Aras on 22/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import SwiftyJSON

class League {
    let id: Int
    let caption: String
    let shortName: String
    let currentMatchday: Int
    let numberOfMatchdays: Int
    let numberOfTeams: Int
    let numberOfGames: Int
    let lastUpdated: String
    //    "id": 436,
    //    "caption": "Primera Division 2016/17",
    //    "league": "PD",
    //    "year": "2016",
    //    "currentMatchday": 29,
    //    "numberOfMatchdays": 38,
    //    "numberOfTeams": 20,
    //    "numberOfGames": 380,
    //    "lastUpdated": "2017-03-22T11:00:11Z"
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.caption = json["caption"].stringValue
        self.shortName = json["shortName"].stringValue
        self.currentMatchday = json["currentMatchday"].intValue
        self.numberOfMatchdays = json["numberOfMatchdays"].intValue
        self.numberOfTeams = json["numberOfTeams"].intValue
        self.numberOfGames = json["numberOfGames"].intValue
        self.lastUpdated = json["lastUpdated"].stringValue
        
    }
    
}
