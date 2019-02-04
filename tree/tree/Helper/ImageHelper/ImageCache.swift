//
//  ImageCache.swift
//  tree
//
//  Created by hyeri kim on 03/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

open class ImageCache {
    let memoryCache = NSCache<AnyObject, AnyObject>()
    
    func store(image: UIImage, name: String) throws {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        guard let imagePath = self.path(for: name) else { return }
        if !FileManager.default.fileExists(atPath: imagePath.path) {
            do {
                try imageData.write(to: imagePath)
            } catch let error as NSError {
                print("error occured \(error)")
            }   
        }
    }
    
    func path(for imageName: String) -> URL? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent(imageName)
    }
}
