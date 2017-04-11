//
//  TeamViewController.swift
//  PrimeraApp
//
//  Created by Marko Aras on 11/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit
import PureLayout
import RxCocoa
import RxSwift

class TeamViewController: UIViewController {

    var team: Team!
    
    var teamVM: TeamViewModel!
    
    let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(team: Team) {
        self.init()
        self.team = team
        self.teamVM = TeamViewModel(team: team)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = team.name
        setupObservables()
    }
    
    func setupObservables() {
        
        teamVM.players.asObservable().subscribe(onNext: { players in
        
            print("players", players.map({ $0.name }))
        }).addDisposableTo(disposeBag)
        
    }

}
