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
        
        self.title = "Standings 2016/2017"
        
        let legend = UIView()
        self.view.addSubview(legend)
        legend.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0), excludingEdge: .bottom)
        legend.autoSetDimension(.height, toSize: 30)
        legend.backgroundColor = UIColor.white
        
        let legendName = UILabel()
        legend.addSubview(legendName)
        legendName.text = "Team"
        legendName.autoAlignAxis(toSuperviewAxis: .horizontal)
        legendName.autoPinEdge(.left, to: .left, of: legend, withOffset: 10)
        
        let legendPoints = UILabel()
        legend.addSubview(legendPoints)
        legendPoints.text = "Points"
        legendPoints.autoAlignAxis(toSuperviewAxis: .horizontal)
        legendPoints.autoPinEdge(.right, to: .right, of: legend, withOffset: -20)
        

        self.view.addSubview(standingsTableView)
        standingsTableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 94, left: 0, bottom: 40, right: 0))
//        standingsTableView.backgroundColor = .red
        
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
