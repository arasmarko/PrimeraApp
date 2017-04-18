//
//  Fixture.swift
//  PrimeraApp
//
//  Created by Marko Aras on 18/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//
import SwiftyJSON

enum FixtureState {
    case finished
    case scheduled
    case postponed
}

class Fixture {
    var date: Date? = nil
    var status: FixtureState? = nil
    var matchday: Int? = nil
    var homeTeamName: String? = nil
    var awayTeamName: String? = nil
    var goalsHomeTeam: Int? = nil
    var goalsAwayTeam: Int? = nil
    var oddsHomeWin: Double? = nil
    var oddsDraw: Double? = nil
    var oddsAwayWin: Double? = nil
    
    init(json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.date = dateFormatter.date(from: json["date"].stringValue)
        
        if json["status"].stringValue == "FINISHED" {
            self.status = .finished
        } else if json["status"].stringValue == "SCHEDULED" {
            self.status = .scheduled
        } else {
            self.status = .postponed
        }
        
        self.matchday = json["matchday"].intValue
        self.homeTeamName = json["homeTeamName"].stringValue
        self.awayTeamName = json["awayTeamName"].stringValue
        self.goalsHomeTeam = json["result"]["goalsHomeTeam"].intValue
        self.goalsAwayTeam = json["result"]["goalsAwayTeam"].intValue
        self.oddsHomeWin = json["odds"]["oddsHomeWin"].doubleValue
        self.oddsDraw = json["odds"]["oddsDraw"].doubleValue
        self.oddsAwayWin = json["odds"]["oddsAwayWin"].doubleValue

    }
    
    
    //    "date": "2016-08-19T18:45:00Z",
    //    "status": "FINISHED",
    //    "matchday": 1,
    //    "homeTeamName": "Málaga CF",
    //    "awayTeamName": "CA Osasuna",
    //    "result": {
    //    "goalsHomeTeam": 1,
    //    "goalsAwayTeam": 1,
    //    "halfTime": {
    //    "goalsHomeTeam": 0,
    //    "goalsAwayTeam": 0
    //    }
    //    },
    //    "odds": {
    //    "homeWin": 1.72,
    //    "draw": 3.6,
    //    "awayWin": 4.8
    //    }
    
}
