//
//  ImagePrefetch.swift
//  tree
//
//  Created by hyeri kim on 03/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

open class ImagePrefetch {
    private var task = [URLSessionTask]()
    private var imageUrl: String?
    
    func cancleLoadingImage(_ articleUrl: String) {
        guard let imageURL = URL(string: articleUrl) else { return }
        guard let taskIndex = task.index(where: { $0.originalRequest?.url == imageURL}) else { return }
        let myTask = task[taskIndex]
        myTask.cancel()
        task.remove(at: taskIndex)
    }
    
    func loadingImage(_ articleUrl: String) {
        imageUrl = articleUrl
        if memoryCache.object(forKey: articleUrl as AnyObject) as? UIImage == nil {
            guard let imageURL = URL(string: articleUrl) else { return }
            guard task.index(where: {$0.originalRequest?.url == imageURL }) == nil else { return }
            let myTask = URLSession.shared.dataTask(with: imageURL) { (data, _, _) in
                DispatchQueue.main.async {
                    print(articleUrl)
                    guard let data = data else { return }
                    guard let getImage = UIImage(data: data) else { return }
                    //disk cache check 
                    //memory cache check
                    memoryCache.setObject(getImage, forKey: self.imageUrl as AnyObject)
                }
            }
            myTask.resume()
            task.append(myTask)
        }
    }
}
