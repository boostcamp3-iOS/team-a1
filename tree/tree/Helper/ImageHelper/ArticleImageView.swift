//
//  ArticleImageView.swift
//  tree
//
//  Created by hyeri kim on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ArticleImage: UIImageView {
    private var task = [URLSessionTask]()
    private var imageUrl: String?
    
    func image(from: Data) {
        self.image = UIImage(data: from)
    }
    
    func loadImage(articleUrl: String) {
        imageUrl = articleUrl
        image = nil
        if let image = ImageManager.shared.loadImageFromCache(articleURL: articleUrl) {
            self.image = image
            return
        } else {       
            if task.count > 5 { return }
            loadImageFromServer(articleUrl: articleUrl)
        }
    }
    
    func loadImageFromServer(articleUrl: String) {
        self.image = nil
        guard let imageURL = URL(string: articleUrl) else { return }
        guard task.index(where: {$0.originalRequest?.url == imageURL }) == nil else { return }
        let myTask = URLSession.shared.dataTask(with: imageURL) { [weak self] (data, _, _) in
            guard let self = self else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return } 
            DispatchQueue.main.async {
                self.image = self.downsampledImage(
                    data: data, 
                    to: self.bounds.size, 
                    scale: self.traitCollection.displayScale
                )
                ImageManager.shared.storeImageToCache(image: image, imageName: articleUrl)
            }            
        }
        myTask.resume()
        task.append(myTask)
    }
    
    func cancelImage(articleUrl: String) {
        guard let imageURL = URL(string: articleUrl) else { return }
        guard let taskIndex = task.index(where:{ 
            $0.originalRequest?.url == imageURL
        }) else { return }
        let myTask = task[taskIndex]
        myTask.cancel()
        task.remove(at: taskIndex)        
    }
    
    func downsampledImage(data: Data, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else { return nil }
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
        return UIImage(cgImage: downsampledImage)
    }
}
