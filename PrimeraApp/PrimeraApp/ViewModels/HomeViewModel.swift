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
    
    
    let x: Observable<Bool>
    
    init() {
        
        x = provider.request(.primera)
            .filterSuccessfulStatusAndRedirectCodes()
            .debug()
            .mapJSON()
            .flatMapLatest({ resposnse -> Observable<Bool> in
                
                let json = JSON(resposnse)
                print(json)
                
                return Observable.just(true)
            })
        
    }
}
