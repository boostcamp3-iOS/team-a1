//
//  Extension+ImageView.swift
//  tree
//
//  Created by hyeri kim on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ArticleImage: UIImageView {
    var imageUrl: String?
    
    func loadImageUrl(articleUrl: String) {
        imageUrl = articleUrl
                
        image = nil
        if let imageFromCache = imageCache.object(forKey: articleUrl as AnyObject) as? UIImage {
            self.image = imageFromCache
        }
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: articleUrl) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: imageData)
                if self.imageUrl == articleUrl {
                    self.image = imageToCache
                }

                if imageToCache != nil {
                    imageCache.setObject(imageToCache!, forKey: articleUrl as AnyObject)
                }
            }
        }
    }
}
