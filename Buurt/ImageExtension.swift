//
//  ImageExtension.swift
//  Buurt
//
//  Used the tutorial of 'Lets Build That App' 
//  https://www.youtube.com/watch?v=GX4mcOOUrWQ
//
//  Created by Martijn de Jong on 25-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImagesWithCache(urlstring: String, uid: String) {
        self.image = nil
        
        // CHECK CACHE FOR IMAGE FIRST
        if let cachedImage = imageCache.object(forKey: urlstring as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }

        let imageUrl = URLRequest(url: URL(string: currentInfo.uidPictureDict[uid]!)!)
        let task = URLSession.shared.dataTask(with: imageUrl) {
            (data, response, error) in
            
            if error != nil {
                print("IMAGEERROR:", error!)
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlstring as AnyObject)
                    self.image = downloadedImage
                }
            }
        }
        task.resume()
    }
}
