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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(team: StandingsTeam) {
        self.addSubview(nameLabel)
        nameLabel.autoPinEdgesToSuperviewEdges()
        
        nameLabel.text = "\(team.position). \(team.name)"
    }

    

}
