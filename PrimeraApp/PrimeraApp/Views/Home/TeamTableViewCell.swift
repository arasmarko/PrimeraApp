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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(team: Team) {
        let imgUrl = team.crestUrl
        self.team = team
        nameLabel.text = team.name
        
        self.addSubview(nameLabel)
        nameLabel.autoPinEdgesToSuperviewEdges()

        
        if let url = URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if data != nil {
                    DispatchQueue.main.async(execute: { () -> Void in
                        if let im = SVGKImage(data: data) {
                            self.teamBackgroundImageView = SVGKLayeredImageView(svgkImage: im)
                            
                            self.addSubview(self.teamBackgroundImageView)
                            self.teamBackgroundImageView.transform = CGAffineTransform(scaleX: self.bounds.width/self.teamBackgroundImageView.bounds.width*0.7, y: self.bounds.height/self.teamBackgroundImageView.bounds.height*1.3)
//                            print("marko1", self.teamBackgroundImageView.bounds.width, self.teamBackgroundImageView.bounds.height)
                            self.teamBackgroundImageView.autoPinEdge(toSuperviewEdge: .right)
                            self.teamBackgroundImageView.autoPinEdge(toSuperviewEdge: .top)
                            self.teamBackgroundImageView.autoPinEdge(toSuperviewEdge: .bottom)
                            self.teamBackgroundImageView.autoSetDimension(.width, toSize: 280)
                            self.teamBackgroundImageView.clipsToBounds = true
                            

                        } else {
                            let imageView = UIImageView(image: UIImage(data: data!))
                            self.insertSubview(imageView, at: 0)
                            imageView.autoPinEdgesToSuperviewEdges()
                            imageView.backgroundColor = .white
                            imageView.contentMode = .scaleAspectFit
                            imageView.clipsToBounds = true

                        }
                        
                    })
                }
            })
            task.resume()
        }
        
    }
    
    override func prepareForReuse() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
