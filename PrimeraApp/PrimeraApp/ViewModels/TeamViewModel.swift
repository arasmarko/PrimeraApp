//
//  TeamViewModel.swift
//  PrimeraApp
//
//  Created by Marko Aras on 11/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class TeamViewModel {
    let provider = RxMoyaProvider<PrimeraAPI>()
    let players: Observable<[Player]>
    let team: Team
    let disposeBag = DisposeBag()
    
    init(team: Team) {
        self.team = team
        
        
        players = provider.request(.players(playersUrl: team.playersLink))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
            .flatMapLatest({ resposnse -> Observable<[Player]> in
                print("request for players")
                let json = JSON(resposnse)
                
                var players: [Player] = []
                
                for (_, subJson) in json["players"] {
                    
                    players.append(Player(json: subJson))
                    
                }
                
                players = players.sorted(by: { $0.jerseyNumber < $1.jerseyNumber })

                
                return Observable.just(players)
            }).catchError({ err in
                if let e = err as? MoyaError {
                    print("Error1 ", e.failureReason, e.helpAnchor, e.recoverySuggestion)
                } else {
                    print("Error ", err.localizedDescription)
                }
                
                return Observable.just([])
            })
    }
    
}
