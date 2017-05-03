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
import CoreData
import RxKeyboard

struct SectionOfTeams {
    var items: [Team]
}
extension SectionOfTeams: SectionModelType {
    
    init(original: SectionOfTeams, items: [Team]) {
        self = original
        self.items = items
    }
}

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate {
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
    
    var fetchedResultsController: NSFetchedResultsController<Query>?
    
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
        
        loadFromCD()
        
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
                self.searchField.endEditing(true)
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
        
        renderRecentSearches(terms: [])
        
        view.addSubview(recentSearches)
        recentSearches.autoPinEdge(.left, to: .left, of: view)
        recentSearches.autoPinEdge(.right, to: .right, of: view)
        recentSearches.autoPinEdge(.top, to: .bottom, of: divider)

        
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(), excludingEdge: .top)
        tableViewTopConstraint = tableView.autoPinEdge(.top, to: .bottom, of: divider)
        
        recentSearches.autoPinEdge(.bottom, to: .top, of: tableView)
        
    }
    
    func renderRecentSearches(terms:[Any]) {
        recentSearches.subviews.forEach({ $0.removeFromSuperview() })
        let container = UIView()
        
        recentSearches.addSubview(container)
        container.autoSetDimension(.width, toSize: view.bounds.width)
        container.autoPinEdge(toSuperviewEdge: .top)
        container.autoPinEdge(toSuperviewEdge: .bottom)
        
        for (index, _) in terms.enumerated() {
            let tmpRecent = UIButton()
            
            if let query = fetchedResultsController?.object(at: IndexPath(row: index, section: 0)) {
                tmpRecent.setTitle(query.term ?? "test123", for: .normal)
                
                container.addSubview(tmpRecent)
                container.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.05)
                
                tmpRecent.autoPinEdge(.left, to: .left, of: container, withOffset: 0)
                tmpRecent.autoPinEdge(.right, to: .right, of: container, withOffset: 0)
                tmpRecent.autoSetDimension(.height, toSize: 44)
                tmpRecent.tag = index
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelect(_:)))
                tmpRecent.addGestureRecognizer(tapGesture)
                
                if index == 0 {
                    tmpRecent.autoPinEdge(.top, to: .top, of: container, withOffset: 10)
                } else if ( index != terms.count - 1) {
                    tmpRecent.autoPinEdge(.top, to: .top, of: container, withOffset: CGFloat(10 + 44*index) )
                } else if ( index == terms.count - 1) {
                    tmpRecent.autoPinEdge(.top, to: .top, of: container, withOffset: CGFloat(10 + 44*index) )
                    tmpRecent.autoPinEdge(.bottom, to: .bottom, of: container, withOffset: 10)
                }
                
            }
            
            tmpRecent.setTitleColor(.black, for: .normal)
            
        }
        
    }
    
    func didSelect(_ tap: UITapGestureRecognizer) {
        if let query = fetchedResultsController?.object(at: IndexPath(row: tap.view!.tag, section: 0)) {
            searchField.text = query.term
            homeVM.simulateFilterTeams(term: query.term ?? "")
        }
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
                }
                return sections
            })
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        searchField.rx.value.asObservable().subscribe(onNext: { _ in
            
        }).addDisposableTo(disposeBag)
        
        searchField.rx.controlEvent(UIControlEvents.editingDidBegin).asObservable().subscribe(onNext: { _ in
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableViewTopConstraint.constant = 80
                self.view.layoutIfNeeded()
            })
            
        }).addDisposableTo(disposeBag)
        
        searchField.rx.controlEvent(UIControlEvents.editingDidEnd).asObservable().subscribe(onNext: { _ in
            if let t = self.searchField.text, (self.searchField.text?.characters.count)! > 3 {
                self.save(q: t)
            }
            
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableViewTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            
        }).addDisposableTo(disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardVisibleHeight in
                self.tableView.contentInset.bottom = keyboardVisibleHeight
            })
            .addDisposableTo(disposeBag)

        
    }
    
}

