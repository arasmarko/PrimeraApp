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
    
    let fixtures: Observable<[Fixture]>
    
    init() {
        
        fixtures = provider.request(.fixtures)
            .filterSuccessfulStatusAndRedirectCodes()
            .mapJSON()
            .flatMapLatest({ resposnse -> Observable<[Fixture]> in
                var fixtures: [Fixture] = []
                let json = JSON(resposnse)
                
                let currentFixture = 0
                for (_, subJson) in json["fixtures"] {
//                    fixtures.append(Fixture(json: subJson))
                    //sorted desc
                    if subJson["matchday"].intValue != currentFixture {
                        fixtures.insert(Fixture(json: subJson), at: 0)
                    }
                    
                }
                
                return Observable.just(fixtures)
            })
        
    }
    
}

