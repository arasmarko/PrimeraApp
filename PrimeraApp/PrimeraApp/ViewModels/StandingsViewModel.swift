//
//  StandingsViewModel.swift
//  PrimeraApp
//
//  Created by Marko Aras on 17/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class StandingsTeam {
    var id: Int = 0
    var position: Int = 0
    var name: String = ""
    var points: Int = 0
    
    init () {}
}

class StandingsViewModel {
    let provider = PrimeraProvider()//RxMoyaProvider<PrimeraAPI>()
    
    let standings: Observable<[StandingsTeam]>
    
    let disposeBag = DisposeBag()
    
    init() {
        
        standings = provider.request(.table)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
            .flatMapLatest({ resposnse -> Observable<[StandingsTeam]> in
                var standingsTeams: [StandingsTeam] = []
                let json = JSON(resposnse)
                
                for (_, subJson) in json["standing"] {
                    var newTeam = StandingsTeam()
                    
                    newTeam = StandingsTeam()
                    
                    let identifier = subJson["_links"]["team"]["href"].stringValue.components(separatedBy: "/teams/")
                    newTeam.id = Int(identifier[1]) ?? 0
                    
                    
                    newTeam.name = subJson["teamName"].stringValue
                    newTeam.points = subJson["points"].intValue
                    newTeam.position = subJson["position"].intValue
                    standingsTeams.append(newTeam)
                    
                }
                return Observable.just(standingsTeams)
            })
    }
    
}
