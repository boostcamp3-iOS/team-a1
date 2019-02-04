//
//  Extension+ImageView.swift
//  tree
//
//  Created by hyeri kim on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ArticleImage: UIImageView {
    private let imageCache = ImageCache()
    private let ioQueue = DispatchQueue(label: "diskCache")
    private var imageUrl: String?

    func loadImageUrl(articleUrl: String) {
        imageUrl = articleUrl
        image = nil
        let extract = self.imageUrl?.components(separatedBy: "/").last

        if let imageFromCache = imageCache.memoryCache.object(forKey: articleUrl as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        } else {
            if let imagePath = imageCache.path(for: extract ?? ""), let imageToDisk = UIImage(contentsOfFile: imagePath.path) {
                self.image = imageToDisk
                self.imageCache.memoryCache.setObject(imageToDisk, forKey: articleUrl as AnyObject)
                return
            }
        }
     
        DispatchQueue.global().async {
            guard let imageURL = URL(string: articleUrl) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: imageData) else { return }
                if self.imageUrl == articleUrl {
                    self.image = imageToCache
                }
                self.imageCache.memoryCache.setObject(imageToCache, forKey: articleUrl as AnyObject)
                self.ioQueue.async {
                    if let path = extract {
                        try?self.imageCache.store(image: imageToCache, name: path)                        
                    }
                }
            }
        }
    }
}
