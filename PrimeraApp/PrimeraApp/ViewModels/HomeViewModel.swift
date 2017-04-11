//
//  HomeViewModel.swift
//  PrimeraApp
//
//  Created by Marko Aras on 22/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class HomeViewModel {
    let provider = RxMoyaProvider<PrimeraAPI>()
    
    
    let league: Observable<League>
    //    var teams: Observable<[Team]>!
    
    var teamsVariable: Variable<[Team]> = Variable([])
    var allTeams: [Team] = []
    let disposeBag = DisposeBag()
    
    init(searchFieldDriver: Driver<String>) {
        
        league = provider.request(.primera)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
            .flatMapLatest({ resposnse -> Observable<League> in
                
                let json = JSON(resposnse)
                let league = League(json: json)
                return Observable.just(league)
            })
        
        getTeams()
        
        searchFieldDriver.asObservable().flatMapLatest { (term) -> Observable<[Team]> in
            
            let filteredTeams = self.allTeams.filter({ (team) -> Bool in
                
                if term.characters.count == 0 {
                    return true
                }
                
                if team.name.lowercased().range(of: term.lowercased()) != nil {
                    return true
                }

                return false
            })
            
            return Observable.just(filteredTeams)
            
            }.subscribe(onNext: {teams in
                print("new teams:", teams)
                self.teamsVariable.value = teams
                
            }).addDisposableTo(disposeBag)
        
    }
    
    func getTeams() {
        
        provider.request(.teams)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
            .flatMapLatest({ resposnse -> Observable<[Team]> in
                var teams: [Team] = []
                let json = JSON(resposnse)
                for (_, subJson) in json["teams"] {
                    
                    teams.append(Team(json: subJson))
                }
                return Observable.just(teams)
            }).subscribe(onNext: { teams in
                self.allTeams = teams
                self.teamsVariable.value = teams
            }).addDisposableTo(disposeBag)
        
    }
}
