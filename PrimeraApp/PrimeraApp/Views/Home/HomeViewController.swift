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
    var tableViewTopConstraint: NSLayoutConstraint!
    
    let recentSearches = UIScrollView()
    
    let cellReuseIdentifier = "TeamCell"
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfTeams>()
    
    let searchField = UITextField()
    let searchIcon = UIImageView(image: UIImage(named: "Search"))
    let divider = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeVM = HomeViewModel(searchFieldDriver: searchField.rx.text.orEmpty.asDriver())//searchFieldDriver: searchField.rx.text.orEmpty.asDriver()
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.rowHeight = 220.0
        tableView.estimatedRowHeight = 220.0
        tableView.separatorStyle = .none
        
        view.backgroundColor = .white
        
        render()
        
        setupObservables()
        
        dataSource.configureCell = { [weak self] (ds, tv, ip, team ) in
            guard let `self` = self else {
                return UITableViewCell()
            }
            
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: ip) as! TeamTableViewCell
            
            cell.selectionStyle = .none
            cell.setupView(team: team)
            return cell
        }
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let cell = self.tableView.cellForRow(at: indexPath)
            
            if let selectedTeam = self.homeVM.allTeams.filter({ $0.id == cell?.tag ?? 0 }).first {
                let teamVC = TeamViewController(team: selectedTeam)
                self.navigationController?.pushViewController(teamVC, animated: true)
            }
            
        }).addDisposableTo(disposeBag)
        
    }
    
    func render() {
        
        view.addSubview(searchIcon)
        searchIcon.autoPinEdge(toSuperviewEdge: .left)
        searchIcon.autoPinEdge(.top, to: .top, of: view, withOffset: 68)
        searchIcon.autoSetDimension(.width, toSize: 36)
        searchIcon.autoSetDimension(.height, toSize: 36)
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.backgroundColor = .white
        
        
        view.addSubview(searchField)
        searchField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(64, 40, 0, 0), excludingEdge: .bottom)
        searchField.autoSetDimension(.height, toSize: 44)
        searchField.backgroundColor = .white
        
        view.addSubview(divider)
        divider.autoSetDimension(.height, toSize: 1)
        divider.autoPinEdge(.left, to: .left, of: view, withOffset: 0)
        divider.autoPinEdge(.right, to: .right, of: view, withOffset: 0)
        divider.autoPinEdge(.top, to: .bottom, of: searchField, withOffset: 0)
        divider.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        renderRecentSearches()
        
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(), excludingEdge: .top)
        tableViewTopConstraint = tableView.autoPinEdge(.top, to: .bottom, of: divider)
        
        recentSearches.autoPinEdge(.bottom, to: .top, of: tableView)
        
    }
    
    func renderRecentSearches() {
        let container = UIView()
        
        view.addSubview(recentSearches)
        recentSearches.autoPinEdge(.left, to: .left, of: view)
        recentSearches.autoPinEdge(.right, to: .right, of: view)
        recentSearches.autoPinEdge(.top, to: .bottom, of: divider)
        
        
        recentSearches.addSubview(container)
        container.autoPinEdgesToSuperviewEdges()
        
        //get this values from CoreData
        //============
        let recent1 = UIButton()
        recent1.setTitle("blabla", for: .normal)
        let recent2 = UIButton()
        recent2.setTitle("blabla2", for: .normal)
        
        container.addSubview(recent1)
        recent1.autoPinEdge(.top, to: .top, of: container, withOffset: 10)
        recent1.autoPinEdge(.left, to: .left, of: container, withOffset: 0)
        recent1.autoPinEdge(.right, to: .right, of: container, withOffset: 0)
        recent1.autoSetDimension(.height, toSize: 44)
        recent1.setTitleColor(.black, for: .normal)
        
        container.addSubview(recent2)
        recent2.autoPinEdge(.top, to: .bottom, of: recent1, withOffset: 10)
        recent2.autoPinEdge(.left, to: .left, of: container, withOffset: 0)
        recent2.autoPinEdge(.right, to: .right, of: container, withOffset: 0)
        recent2.autoSetDimension(.height, toSize: 44)
        recent2.setTitleColor(.black, for: .normal)
        
        recent2.autoPinEdge(.bottom, to: .bottom, of: container, withOffset: 0)
        //============
        
        //bind click on this button to change the search bar text filed input
            //by doing this you trigger search, resulting in showing filtered results :)
            //have fun
        
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
        
        searchField.rx.value.asObservable().subscribe(onNext: { _ in
            
        }).addDisposableTo(disposeBag)
        
        searchField.rx.controlEvent(UIControlEvents.editingDidBegin).asObservable().subscribe(onNext: { _ in
            print("editingDidBegin")
            self.tableViewTopConstraint.constant = 80
        }).addDisposableTo(disposeBag)
        
        searchField.rx.controlEvent(UIControlEvents.editingDidEnd).asObservable().subscribe(onNext: { _ in
            //TODO [Tamara] save to CoreData
            //value is in self.searchField.text
            //append this to recentSearches scrollView container
            
            self.tableViewTopConstraint.constant = 0
        }).addDisposableTo(disposeBag)

    }
}

