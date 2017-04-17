//
//  PrimeraProvider.swift
//  PrimeraApp
//
//  Created by Marko Aras on 17/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire
import SwiftyJSON

class PrimeraProvider: RxMoyaProvider<PrimeraAPI> {
    
    init() {
        let endpointClosure = { (target: PrimeraAPI) -> Endpoint<PrimeraAPI> in
            let defaultEndpoint = RxMoyaProvider.defaultEndpointMapping(for: target)
            
            let token = "903a40fb1e37410b8ea57c02f454584a"
            return defaultEndpoint.adding(newHTTPHeaderFields: ["X-Auth-Token": token])

            
        }
        
        super.init(endpointClosure: endpointClosure)
    }
    
}

