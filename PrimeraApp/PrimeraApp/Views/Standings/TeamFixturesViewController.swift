//
//  TeamFixturesViewController.swift
//  PrimeraApp
//
//  Created by Marko Aras on 18/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit
import PureLayout
import RxSwift
import RxCocoa
import RxDataSources
import SVGKit

struct SectionOfFixtures {
    var items: [Fixture]
}

extension SectionOfFixtures: SectionModelType {
    
    init(original: SectionOfFixtures, items: [Fixture]) {
        self = original
        self.items = items
    }
}

class TeamFixturesViewController: UIViewController {
    
    let cellReuseIdentifier = "TeamFixtureCell"
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfStandingTeams>()
    let teamFixturesTableView = UITableView()
    let disposeBag = DisposeBag()
    let standingsVM = StandingsViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(teamFixturesTableView)
        teamFixturesTableView.autoPinEdgesToSuperviewEdges()
        teamFixturesTableView.backgroundColor = .red
        
        teamFixturesTableView.register(TeamFixtureTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        teamFixturesTableView.rowHeight = 60.0
        teamFixturesTableView.estimatedRowHeight = 60.0
        teamFixturesTableView.separatorStyle = .none
        
//        dataSource.configureCell = { [weak self] (ds, tv, ip, team ) in
//            guard let `self` = self else {
//                return UITableViewCell()
//            }
//            let cell = tv.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: ip) as! TeamFixtureTableViewCell
//            
//            cell.tag = team.id
//            cell.selectionStyle = .none
//            cell.setupView(fixture: team)
//            return cell
//        }
//        
//        teamFixturesTableView.rx.itemSelected.subscribe(onNext: { indexPath in
//            print("klik:")
//        }).addDisposableTo(disposeBag)
//        
//        standingsVM.standings.asObservable()
//            .observeOn(MainScheduler.instance)
//            .map({ teams in
//                var sections: [SectionOfStandingTeams] = []
//                if teams.count > 0 {
//                    sections.append(SectionOfStandingTeams.init(items: teams))
//                } else {
//                    //                    sections.append()
//                }
//                return sections
//            })
//            .bindTo(teamFixturesTableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
        
    }


}
