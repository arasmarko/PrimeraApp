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
import RxCocoa
import RxDataSources

struct SectionOfTeams {
    var items: [Team]
}
extension SectionOfTeams: SectionModelType {
    
    init(original: SectionOfTeams, items: [Team]) {
        self = original
        self.items = items
    } 
}

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    let homeVM = HomeViewModel()
    let tableView = UITableView()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfTeams>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
        
        setupObservables()
        
        dataSource.configureCell = {  (ds, tv, ip, team ) in//[weak self]
//            guard let `self` = self else {
//                return UITableViewCell()
//            }
            let cell = UITableViewCell()//tv.dequeueReusableCell(withIdentifier: "Cell", for: ip)
            cell.textLabel?.text = "Item: \(team.name)"
            return cell
        }
        
    }
    
    func render() {
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    func setupObservables() {
        homeVM.league.subscribe(onNext: { league in
            self.title = league.caption
        }).addDisposableTo(disposeBag)
        
        homeVM.teams
            .observeOn(MainScheduler.instance)
            .map({ teams in
                var sections: [SectionOfTeams] = []
                if teams.count > 0 {
                    sections.append(SectionOfTeams.init(items: teams))
                } else {
//                    sections.append()
                }
                return sections
            })
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}

