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
    
    let cellReuseIdentifier = "TeamCell"
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfTeams>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            cell.textLabel?.text = team.name
            
//            cell.setupView(team: team)
            
//            cell.teamBackgroundImageView.image =
            
//            cell.teamBackgroundImageView.
            
//            let imgUrl = team.crestUrl
//            
//            if let url: URL = URL(string: imgUrl) {
//                let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                    if data != nil {
//                        print("mogu ", team.crestUrl)
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            print(data)
//                            cell.teamBackgroundImageView.image = UIImage(data: data!)
//                        })
//                    }
//                })
//                task.resume()
//
//            } else {
//                print("ne mogu ", team.crestUrl)
//            }
            
            
            
            cell.selectionStyle = .none
            cell.setupView(team: team)
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

