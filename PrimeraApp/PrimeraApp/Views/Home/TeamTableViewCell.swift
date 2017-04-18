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
        let contentView = UIView()
        self.addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        let imgUrl = team.crestUrl
        self.team = team
        nameLabel.text = team.name
        
        tag = team.id
        
        contentView.addSubview(nameLabel)
        nameLabel.autoAlignAxis(.horizontal, toSameAxisOf: contentView)
        nameLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: 20)

        
        if let url = URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if data != nil {
                    DispatchQueue.main.async(execute: { () -> Void in
                        if let im = SVGKImage(data: data) {
//                            self.teamBackgroundImageView = SVGKLayeredImageView(svgkImage: im)
                            
//                            contentView.addSubview(self.teamBackgroundImageView)
//                            self.teamBackgroundImageView.transform = CGAffineTransform(scaleX: self.bounds.width/self.teamBackgroundImageView.bounds.width, y: self.bounds.height/self.teamBackgroundImageView.bounds.height)
//                            print("marko1", self.teamBackgroundImageView.bounds.width, self.teamBackgroundImageView.bounds.height)
//                            self.teamBackgroundImageView.autoPinEdgesToSuperviewEdges()
//                            self.teamBackgroundImageView.autoPinEdge(toSuperviewEdge: .top)
//                            self.teamBackgroundImageView.autoPinEdge(toSuperviewEdge: .left)
//                            self.teamBackgroundImageView.autoSetDimension(.height, toSize: 280)
//                            self.teamBackgroundImageView.clipsToBounds = true
                            

                        } else {
//                            let imageView = UIImageView(image: UIImage(data: data!))
//                            self.insertSubview(imageView, at: 0)
//                            imageView.autoPinEdgesToSuperviewEdges()
//                            imageView.backgroundColor = .white
//                            imageView.contentMode = .scaleAspectFit
//                            imageView.clipsToBounds = true

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
