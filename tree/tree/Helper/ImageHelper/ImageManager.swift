//
//  ImageManager.swift
//  tree
//
//  Created by hyeri kim on 22/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

open class ImageManager {
    let imageCahce = ImageCache()
    
    func loadImageFromCache(articleURL: String) -> UIImage? {
        if let image = imageCahce.getImageFromMemoryCache(articleUrl: articleURL) {
            return image
        } else {
            if let path = articleURL.components(separatedBy: "/").last, 
                let imagePath = imageCahce.path(for: path),
                let image = UIImage(contentsOfFile: imagePath.path) {
                    imageCahce.imageStoreToMemory(image: image, imageName: articleURL)
                return image
            }
        }
        return nil
    }
    
    func storeImageToCache(image: UIImage, imageName: String) {
        if let extract = imageName.components(separatedBy: "/").last {
            imageCahce.serverImageStoreToDisk(image: image, imageName: extract)
        }
    }
}
