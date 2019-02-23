//
//  ImageCache.swift
//  tree
//
//  Created by hyeri kim on 03/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

open class ImageCache {
    static let shared = ImageCache()
    let memoryCache = NSCache<AnyObject, AnyObject>()
    let maxCount = 5
    private let ioQueue = DispatchQueue(label: "diskCache")
    
    func getImageFromMemoryCache(articleUrl: String) -> UIImage? {
        if let memoryImage = memoryCache.object(forKey: articleUrl as AnyObject) as? UIImage {
            return memoryImage
        } 
        return nil
    }
    
    func getImageFromDisckCache(imagePath: String) -> UIImage? {
        if let imagePath = path(for: imagePath),
            let diskImage = UIImage(contentsOfFile: imagePath.path) {
                return diskImage
        } 
        return nil
    }
    
    func imageStoreToMemory(image: UIImage, imageName: String) {
        memoryCache.setObject(image, 
                              forKey: imageName as AnyObject
        )
    }
    
    func path(for imageName: String) -> URL? {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent(imageName)
    }
    
    func imageStoreToDisk(image: UIImage, name: String) throws {
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
    
    func serverImageStoreToDisk(image: UIImage, imageName: String) {
        ioQueue.async {
            try? self.imageStoreToDisk(image: image, name: imageName)
        }
    }
    
    func removeAllImages() {
        let diskCache = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        if let appId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as? String {
            let path = String(format:"%@/%@/Cache.db-wal", diskCache, appId)
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print("ERROR DESCRIPTION: \(error)")
            }
        }
    }
}
