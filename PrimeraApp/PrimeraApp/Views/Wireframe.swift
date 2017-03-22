//
//  Wireframe.swift
//  PrimeraApp
//
//  Created by Marko Aras on 22/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import UIKit

class Wireframe {
    static let shared = Wireframe()
    
    var window: UIWindow!
    
    func start(window: UIWindow) {
        self.window = window
        window.rootViewController = UINavigationController(rootViewController: HomeViewController())
        
    }
    
}

