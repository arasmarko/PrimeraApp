//
//  TeamTableViewCell.swift
//  PrimeraApp
//
//  Created by Marko Aras on 23/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit
import PureLayout

class TeamTableViewCell: UITableViewCell {
    
    let teamBackgroundImageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(teamBackgroundImageView)
        teamBackgroundImageView.autoPinEdgesToSuperviewEdges()
        teamBackgroundImageView.backgroundColor = .white
        
        self.addSubview(nameLabel)
        nameLabel.autoPinEdgesToSuperviewEdges()
        nameLabel.text = "Marko"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(team: Team) {
        let imgUrl = team.crestUrl
        //ne rodi
        
        //print(imgUrl)
//        let url = URL(string: imgUrl)
        
        //let data = try? Data(contentsOf: url!)
        //if ()
        //teamBackgroundImageView.image = UIImage(data: data!)
        

//        let escapedString = imgUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//        let url: URL = URL(string: "www.w3schools.com/css/trolltunga.jpg")!
        
//        print("govno: ", escapedString)
        
//        teamBackgroundImageView.downloadImage(URL(string: escapedString!)!, placeholderImage: nil)
        
//        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            if data != nil {
//                DispatchQueue.main.async(execute: { () -> Void in
//                    self.teamBackgroundImageView.image = UIImage(data: data!)
//                })
//            }
//        })
//        task.resume()

        
        let url = URL(string: team.crestUrl)
        teamBackgroundImageView.kf.setImage(with: url)
    }
    
}
