//
//  ExtensionUIImageView.swift
//  ImageGridView
//
//  Created by Michele Fadda on 04/06/2020.
//

import UIKit

public let imageCache = NSCache<AnyObject, AnyObject>()

public extension UIImageView {
    func fetchImage(from url:URL) {
        self.image = nil
        let imageFromCache = imageCache.object(forKey: url as AnyObject)
        
        if let imageFromCache = imageFromCache as? UIImage {
            self.image = imageFromCache
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard err == nil
                    else {
                        print (err?.localizedDescription)
                        return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let imageToCache = UIImage(data: data) {
                            imageCache.setObject(imageToCache as! AnyObject, forKey: url as! AnyObject)
                            self.image = imageToCache
                        }
                    }
                }
            }.resume()
        }
    }
}


