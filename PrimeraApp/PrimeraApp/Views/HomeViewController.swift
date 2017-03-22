//
//  ViewController.swift
//  PrimeraApp
//
//  Created by Marko Aras on 22/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit
import PureLayout
import RxSwift

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        let vm = HomeViewModel()
        
        vm.x.subscribe(onNext: { res in
            print("res :)")
        }).addDisposableTo(disposeBag)
        
        
        
    }

}

