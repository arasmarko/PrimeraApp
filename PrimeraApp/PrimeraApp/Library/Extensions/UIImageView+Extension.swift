//
//  UIImageView+Extension.swift
//  PrimeraApp
//
//  Created by Marko Aras on 29/03/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    
    /**
     Download image from the API using Kingfisher. If app is in development mode, add server authentication header.
     
     - parameter URL:              image url
     - parameter placeholderImage: image
     */
    func downloadImage(_ URL: Foundation.URL, placeholderImage: UIImage?) {
//        if Constants.AppMode == .dev {
//            var headers = KingfisherManager.shared.downloader.sessionConfiguration.httpAdditionalHeaders ?? [:]
//            let authString = "miturf:Miturfspaces123"
//            let utf8str = authString.data(using: String.Encoding.utf8)
//            
//            if let base64Encoded = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//            {
//                //print("Encoded:  \(base64Encoded)")
//                headers["Authorization"] = "Basic \(base64Encoded)"
//            }
//            
//            let configuration = URLSessionConfiguration.default
//            configuration.httpAdditionalHeaders = headers
//            KingfisherManager.shared.downloader.sessionConfiguration = configuration
//            
//        }
        
        
        
        self.kf.setImage(with: URL, placeholder: placeholderImage, options: [.transition(.fade(0.1))], progressBlock: nil) { (image, error, cacheType, imageURL) -> () in
            //if let error = error {
            
            //}
            
        }
    }
    
}

