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
//import RxCocoa
import RxDataSources
import SVGKit

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
    var homeVM: HomeViewModel!
    let tableView = UITableView()
    
    let cellReuseIdentifier = "TeamCell"
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfTeams>()
    
    let searchField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeVM = HomeViewModel(searchFieldDriver: searchField.rx.text.orEmpty.asDriver())//searchFieldDriver: searchField.rx.text.orEmpty.asDriver()
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.rowHeight = 220.0
        tableView.estimatedRowHeight = 220.0
        tableView.separatorStyle = .none
        
        
        render()
        
        setupObservables()
        
        dataSource.configureCell = {  (ds, tv, ip, team ) in//[weak self]
            //            guard let `self` = self else {
            //                return UITableViewCell()
            //            }
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: ip) as! TeamTableViewCell
            
            cell.selectionStyle = .none
            cell.setupView(team: team)
            return cell
        }
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("klik:" , self.homeVM.allTeams[indexPath.row].name)
            
            let teamVC = TeamViewController(team: self.homeVM.allTeams[indexPath.row])
            
            self.navigationController?.pushViewController(teamVC, animated: true)
            
        }).addDisposableTo(disposeBag)
        
    }
    
    func render() {
        view.addSubview(searchField)
        searchField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(64, 0, 0, 0), excludingEdge: .bottom)
        searchField.autoSetDimension(.height, toSize: 44)
        searchField.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(), excludingEdge: .top)
        tableView.autoPinEdge(.top, to: .bottom, of: searchField)
        
    }
    
    func setupObservables() {
        
        homeVM.league.subscribe(onNext: { league in
            self.title = league.caption
        }).addDisposableTo(disposeBag)
        
        
        homeVM.teamsVariable.asObservable().skip(1)
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

