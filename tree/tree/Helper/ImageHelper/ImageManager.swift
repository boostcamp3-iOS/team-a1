//
//  ImageManager.swift
//  tree
//
//  Created by hyeri kim on 22/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    func loadImageFromCache(articleURL: String) -> UIImage? {
        if let image = ImageCache.shared.loadImageFromMemoryCache(articleUrl: articleURL) {
            return image
        } else {
            if let path = articleURL.components(separatedBy: "/").last, 
                let imagePath = ImageCache.shared.path(for: path),
                let image = UIImage(contentsOfFile: imagePath.path) {
                    ImageCache.shared.imageStoreToMemory(image: image, imageName: articleURL)
                return image
            }
        }
        return nil
    }
    
    func storeImageToCache(image: UIImage, imageName: String) {
        if let extract = imageName.components(separatedBy: "/").last {
            ImageCache.shared.serverImageStoreToDisk(image: image, imageName: extract)
        }
    }
}
