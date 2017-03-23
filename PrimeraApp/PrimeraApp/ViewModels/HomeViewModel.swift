//
//  HomeViewModel.swift
//  PrimeraApp
//
//  Created by Marko Aras on 22/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

class HomeViewModel {
    let provider = RxMoyaProvider<PrimeraAPI>()
    
    
    let league: Observable<League>
    let teams: Observable<[Team]>
    
    init() {
        
        league = provider.request(.primera)
            .filterSuccessfulStatusAndRedirectCodes()
            .debug()
            .mapJSON()
            .flatMapLatest({ resposnse -> Observable<League> in
                
                let json = JSON(resposnse)
                let league = League(json: json)
                return Observable.just(league)
            })
        
        teams = provider.request(.teams)
            .filterSuccessfulStatusAndRedirectCodes()
            .debug()
            .mapJSON()
            .flatMapLatest({ resposnse -> Observable<[Team]> in
                var teams: [Team] = []
                let json = JSON(resposnse)
                for (_, subJson) in json["teams"] {
                    
                    teams.append(Team(name: subJson["name"].stringValue))
                }
                return Observable.just(teams)
            })
        
    }
}
