//
//  FixturesViewController.swift
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
    var header: String
    var items: [Fixture]
}

extension SectionOfFixtures: SectionModelType {
    
    init(original: SectionOfFixtures, items: [Fixture]) {
        self = original
        self.items = items
    }
    
}

class FixturesViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let fixturesVM = FixturesViewModel()
    
    let cellReuseIdentifier = "FixtureCell"
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfFixtures>()
    
    let fixturesTableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(fixturesTableView)
        fixturesTableView.autoPinEdgesToSuperviewEdges()
        fixturesTableView.backgroundColor = .red
        
        fixturesTableView.register(FixtureTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        fixturesTableView.rowHeight = 60.0
        fixturesTableView.estimatedRowHeight = 60.0
        fixturesTableView.separatorStyle = .none
        
        dataSource.configureCell = { [weak self] (ds, tv, ip, fixture ) in
            guard let `self` = self else {
                return UITableViewCell()
            }
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: ip) as! FixtureTableViewCell
            
            cell.selectionStyle = .none
            cell.setupView(fixture: fixture)
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
        
        fixturesTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("klik:")
        }).addDisposableTo(disposeBag)
        
        fixturesVM.fixtures.asObservable()
            .observeOn(MainScheduler.instance)
            .map({ fixtures in
                var sections: [SectionOfFixtures] = []
                
                var lastPlayedFixture: Fixture?
                
                if fixtures.count > 0 {
                    var fixturesForCurrentMatchday: [Fixture] = []
                    var currentMatchday = 1
                    
                    for (index, fixture) in fixtures.enumerated() {
                        
                        if fixture.status == FixtureState.finished  {
                            lastPlayedFixture = fixture
                        }
                        
                        if (currentMatchday == fixture.matchday && index+1 != fixtures.count) {
                            print("marko: ", currentMatchday)
                            fixturesForCurrentMatchday.append(fixture)
                        } else {
                            print("marko else: ", currentMatchday)
                            if fixturesForCurrentMatchday.count > 0 {
                                sections.append(SectionOfFixtures.init(header: "\(currentMatchday)", items: fixturesForCurrentMatchday))
                                fixturesForCurrentMatchday = []
                            }
                            fixturesForCurrentMatchday.append(fixture)
                            currentMatchday = fixture.matchday ?? 0
                            
                        }
                        
                    }
                    
                }
                
                //                self.fixturesTableView.scrollToRow(at: IndexPath.init(row: 1, section: lastPlayedFixture?.matchday ?? 0), at: UITableViewScrollPosition.top, animated: true)
                
                return sections
            })
            .bindTo(fixturesTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
    }
    
    
}
