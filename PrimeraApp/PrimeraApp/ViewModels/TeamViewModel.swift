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
                
                let json = JSON(resposnse)
                
                var players: [Player] = []
                
                for (_, subJson) in json["players"] {
                    
                    players.append(Player(json: subJson))
                }

                
                return Observable.just(players)
            })
    }
    
}
