//
//  StandingsViewController.swift
//  PrimeraApp
//
//  Created by Marko Aras on 17/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit
import PureLayout
import RxSwift
import RxCocoa
import RxDataSources
import SVGKit

struct SectionOfStandingTeams {
    var items: [StandingsTeam]
}

extension SectionOfStandingTeams: SectionModelType {
    
    init(original: SectionOfStandingTeams, items: [StandingsTeam]) {
        self = original
        self.items = items
    }
}

class StandingsViewController: UIViewController {
    let disposeBag = DisposeBag()
    let standingsVM = StandingsViewModel()
    
    let cellReuseIdentifier = "StandingsTeamCell"
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfStandingTeams>()
    
    let standingsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        standingsVM.standings.subscribe(onNext: { a in
//            print("govno")
//        }).addDisposableTo(disposeBag)
        
        
        self.view.addSubview(standingsTableView)
        standingsTableView.autoPinEdgesToSuperviewEdges()
        standingsTableView.backgroundColor = .red
        
        standingsTableView.register(StandingTeamTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        standingsTableView.rowHeight = 60.0
        standingsTableView.estimatedRowHeight = 60.0
        standingsTableView.separatorStyle = .none
        
        dataSource.configureCell = { [weak self] (ds, tv, ip, team ) in
            guard let `self` = self else {
                return UITableViewCell()
            }
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: ip) as! StandingTeamTableViewCell
            
            cell.tag = team.id
            cell.selectionStyle = .none
            cell.setupView(team: team)
            return cell
        }
        
        standingsTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("klik:")
        }).addDisposableTo(disposeBag)
        
        standingsVM.standings.asObservable()
            .observeOn(MainScheduler.instance)
            .map({ teams in
                var sections: [SectionOfStandingTeams] = []
                if teams.count > 0 {
                    sections.append(SectionOfStandingTeams.init(items: teams))
                } else {
                    //                    sections.append()
                }
                return sections
            })
            .bindTo(standingsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)


        
    }

}
