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
    private var task = [URLSessionTask]()
    private var imageUrl: String?
    
    func image(from: Data) {
        self.image = UIImage(data: from)
    }
    
    func cancelLoadingImage(_ articleUrl: String) {
        guard let imageURL = URL(string: articleUrl) else { return }
        guard let taskIndex = task.index(where: { $0.originalRequest?.url == imageURL}) else { return }
        let myTask = task[taskIndex]
        myTask.cancel()
        task.remove(at: taskIndex)
    }
    
    func loadImageUrl(articleUrl: String) {
        imageUrl = articleUrl
        image = nil
        let extract = self.imageUrl?.components(separatedBy: "/").last

        if let imageFromCache = imageCache.memoryCache.object(forKey: articleUrl as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        } else {
            if let path = extract, 
                let imagePath = imageCache.path(for: path), 
                let imageToDisk = UIImage(contentsOfFile: imagePath.path) {
                self.image = imageToDisk
                self.imageCache.memoryCache.setObject(imageToDisk, forKey: articleUrl as AnyObject)
                return
            }
        }
        guard let imageURL = URL(string: articleUrl) else { return }
        guard task.index(where: {$0.originalRequest?.url == imageURL }) == nil else { return }
        let myTask = URLSession.shared.dataTask(with: imageURL) { [weak self] (data, _, _) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let data = data else { return }
                guard let imageToCache = UIImage(data: data) else { return }
                if self.imageUrl == articleUrl {
                    self.image = self.downsampledImage(data: data, to: self.bounds.size, scale: 1)
                }
                self.ioQueue.async {
                    if let path = extract {
                        try? self.imageCache.store(image: imageToCache, name: path) 
                    }
                }
            }
        }
        myTask.resume()
        task.append(myTask)
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
