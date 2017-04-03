//
//  TeamTableViewCell.swift
//  PrimeraApp
//
//  Created by Marko Aras on 23/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit
import PureLayout
import SVGKit

class TeamTableViewCell: UITableViewCell {
    
    var teamBackgroundImageView: SVGKLayeredImageView!
    let nameLabel = UILabel()
    var team: Team!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameLabel)
        nameLabel.autoPinEdgesToSuperviewEdges()
        
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
        self.team = team
        nameLabel.text = team.name
//        teamBackgroundImageView.image = UIImage(named: "intro")
        
        //print(imgUrl)
        if let url = URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if data != nil {
                    DispatchQueue.main.async(execute: { () -> Void in
                        if let im = SVGKImage(data: data) {
                            self.teamBackgroundImageView = SVGKLayeredImageView(svgkImage: im)
                            self.insertSubview(self.teamBackgroundImageView, at: 0)
                            self.teamBackgroundImageView.autoPinEdgesToSuperviewEdges()
                            self.teamBackgroundImageView.backgroundColor = .white
                            self.teamBackgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
                            self.teamBackgroundImageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 50, height: 50)
//                            self.teamBackgroundImageView.transform = CGAffineTransform.identity.rotated(by: 5.6)
//                            self.teamBackgroundImageView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                            self.teamBackgroundImageView.clipsToBounds = true

                        } else {
                            let imageView = UIImageView(image: UIImage(data: data!))
                            self.insertSubview(imageView, at: 0)
                            imageView.autoPinEdgesToSuperviewEdges()
                            imageView.backgroundColor = .white
                            imageView.contentMode = .scaleAspectFit
//                            imageView.transform = CGAffineTransform.identity.rotated(by: 5.6)
//                            imageView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                            imageView.clipsToBounds = true

                        }
                        
                    })
                }
            })
            task.resume()
        }
        
        //let data = try? Data(contentsOf: url!)
        //if ()
        //teamBackgroundImageView.image = UIImage(data: data!)
        

//        let escapedString = imgUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//        let url: URL = URL(string: "www.w3schools.com/css/trolltunga.jpg")!
        
//        print("govno: ", escapedString)
        
//        teamBackgroundImageView.downloadImage(URL(string: escapedString!)!, placeholderImage: nil)
        
        
        
        

        
//        let url = URL(string: team.crestUrl)
//        teamBackgroundImageView.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
}
