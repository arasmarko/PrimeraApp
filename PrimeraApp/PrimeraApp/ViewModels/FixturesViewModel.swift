//
//  FixturesViewModel.swift
//  PrimeraApp
//
//  Created by Marko Aras on 18/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON


class FixturesViewModel {
    let provider = PrimeraProvider()
    
    let disposeBag = DisposeBag()
    
    init() {
        
//        standings = provider.request(.fixtures)
//            .filterSuccessfulStatusAndRedirectCodes()
//            .mapJSON()
//            .flatMapLatest({ resposnse -> Observable<[StandingsTeam]> in
//                var standingsTeams: [StandingsTeam] = []
//                let json = JSON(resposnse)
//                
//                for (_, subJson) in json["standing"] {
//                    var newTeam = StandingsTeam()
//                    
//                    newTeam = StandingsTeam()
//                    newTeam.name = subJson["teamName"].stringValue
//                    newTeam.points = subJson["points"].intValue
//                    newTeam.position = subJson["position"].intValue
//                    
//
//                    standingsTeams.append(newTeam)
//                }
//                return Observable.just(standingsTeams)
//            })
        
    }
    
}

