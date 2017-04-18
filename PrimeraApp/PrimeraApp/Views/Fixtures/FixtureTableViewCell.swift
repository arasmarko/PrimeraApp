//
//  FixtureTableViewCell.swift
//  PrimeraApp
//
//  Created by Marko Aras on 18/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit

class FixtureTableViewCell: UITableViewCell {

    let nameLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(fixture: Fixture) {
        self.addSubview(nameLabel)
        nameLabel.autoPinEdgesToSuperviewEdges()
        nameLabel.textAlignment = .center
        //TODO if let
        if fixture.status == .finished {
            nameLabel.text = "\(fixture.homeTeamName ?? "")  \(fixture.goalsHomeTeam ?? 0) - \(fixture.goalsAwayTeam ?? 0) \(fixture.awayTeamName ?? "")"
        } else {
            nameLabel.text = "\(fixture.homeTeamName ?? "")  -  \(fixture.awayTeamName ?? "")"
        }
        
    }
    
}
