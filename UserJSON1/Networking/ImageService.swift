//
//  ImageService.swift
//  UserJSON1
//
//  Created by Aron Veress on 23/08/2022.
//

import UIKit

class ImageService {
    static let sharedInstance = ImageService()
    
    private var images: [String: UIImage] = Dictionary<String, UIImage>()
    
    
    func requestImage(url: URL, onSuccess: @escaping ((UIImage)->Void)) {
        if(self.images[url.absoluteString] != nil) {
            if let image = self.images[url.absoluteString]{
                onSuccess(image)
            }
        } else {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

                if let data = data, let image = UIImage(data: data){
                    self.images[url.absoluteString] = image
                    onSuccess(image)
                }
            }
            task.resume()
        }
    }
}

