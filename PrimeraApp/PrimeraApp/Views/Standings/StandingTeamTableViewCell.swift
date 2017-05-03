//
//  StandingTeamTableViewCell.swift
//  PrimeraApp
//
//  Created by Marko Aras on 17/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit
import PureLayout

class StandingTeamTableViewCell: UITableViewCell {
    let nameLabel = UILabel()
    let pointsLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(team: StandingsTeam) {
        self.addSubview(nameLabel)
        nameLabel.autoPinEdge(toSuperviewEdge: .left)
        nameLabel.autoPinEdge(toSuperviewEdge: .top)
        nameLabel.autoPinEdge(toSuperviewEdge: .bottom)
        nameLabel.text = "\(team.position). \(team.name)"
        
        self.addSubview(pointsLabel)
        pointsLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -20)
        pointsLabel.autoPinEdge(toSuperviewEdge: .top)
        pointsLabel.autoPinEdge(toSuperviewEdge: .bottom)
        pointsLabel.text = "\(team.points)"
    }

    

}
