//
//  Team.swift
//  PrimeraApp
//
//  Created by Marko Aras on 22/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import SwiftyJSON

//enum Teams: String {
//    case MAL = "bhttps://pbs.twimg.com/profile_images/699004768870596609/ChH7JCzn.jpg"
//    case OSA = "https://s-media-cache-ak0.pinimg.com/564x/e2/6d/75/e26d75018fd6e47f2db1a7d28067ad59.jpg"
//    case LAC = "https://upload.wikimedia.org/wikipedia/bs/d/da/Logo_Deportivo_de_La_Coru%C3%B1a.png"
//    case EIB = "https://upload.wikimedia.org/wikipedia/commons/4/46/SDEibar_escudo_2017.png"
//    case FCB = "http://www.intellectualpropertymagazine.com/incoming/article113729.ece/ALTERNATES/w940/xshutterstock_285023282.jpg.pagespeed.ic.V-c-Qf2GQ-.jpg"
//    case BET = "https://upload.wikimedia.org/wikipedia/hr/f/f1/Real_Betis.png"
//    case GCF = "bla bla"
//    case VCF = "bla bla"
//    case SEV = "bla bla"
//    case ESP = "bla bla"
//    case SPO = "bla bla"
//    case BIL = "bla bla"
//    case RSS = "bla bla"
//    case MAD = "bla bla"
//    case ATM = "bla bla"
//    case ALA = "bla bla"
//    case VIG = "bla bla"
//    case LEG = "bla bla"
//    case VAL = "bla bla"
//    case LPA = "bla bla"
//}

class Team {
    let id: Int
    let name: String
    let shortName: String
    let crestUrl: String
    let squadMarketValue: String
    let teamLink: String
    let fixturesLink: String
    let playersLink: String
    
    init(json: JSON) {
        self.id = Int(json["_links"]["self"]["href"].stringValue.components(separatedBy: "/teams/")[1]) ?? 0
        self.name = json["name"].stringValue
        self.shortName = json["shortName"].stringValue
        self.crestUrl = json["crestUrl"].stringValue
        self.squadMarketValue = json["squadMarketValue"].stringValue
        
        self.teamLink = json["_links"]["self"]["href"].stringValue.components(separatedBy: "/v1")[1]
        self.fixturesLink = json["_links"]["fixtures"]["href"].stringValue.components(separatedBy: "/v1")[1]
        self.playersLink = json["_links"]["players"]["href"].stringValue.components(separatedBy: "/v1")[1]
        
//        print("teamLink", self.teamLink)
        
    }
    
}
