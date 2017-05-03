//
//  TeamViewController.swift
//  PrimeraApp
//
//  Created by Marko Aras on 11/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit
import PureLayout
import RxSwift
import RxCocoa
import RxDataSources
import SVGKit

struct SectionOfPlayers {
    var items: [Player]
}

extension SectionOfPlayers: SectionModelType {
    
    init(original: SectionOfPlayers, items: [Player]) {
        self = original
        self.items = items
    }
}


class TeamViewController: UIViewController {

    var team: Team!
    
    var teamVM: TeamViewModel!
    
    let cellReuseIdentifier = "PlayerCell"
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfPlayers>()
    let playersTableView = UITableView()

    
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
        
        self.view.addSubview(playersTableView)
        playersTableView.autoPinEdgesToSuperviewEdges()
//
        playersTableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        playersTableView.rowHeight = 60.0
        playersTableView.estimatedRowHeight = 60.0
        playersTableView.separatorStyle = .none
        
        dataSource.configureCell = { [weak self] (ds, tv, ip, player ) in
            guard let `self` = self else {
                return UITableViewCell()
            }
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: ip) as! PlayerTableViewCell
            
            cell.selectionStyle = .none
            cell.setupView(player: player)
            return cell
        }
        
//        playersTableView.rx.itemSelected.subscribe(onNext: { indexPath in
//            print("klik:")
//        }).addDisposableTo(disposeBag)
        
        
    }
    
    func setupObservables() {
        
//        teamVM.players.asObservable().subscribe(onNext: { players in
//            print("players", players.map({ $0.name }))
//        }).addDisposableTo(disposeBag)
//
        teamVM.players.asObservable()
            .observeOn(MainScheduler.instance)
            .map({ players in
                var sections: [SectionOfPlayers] = []
                if players.count > 0 {
                    sections.append(SectionOfPlayers.init(items: players))
                } else {
                    //                    sections.append()
                }
                return sections
            })
            .bindTo(playersTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }

}
