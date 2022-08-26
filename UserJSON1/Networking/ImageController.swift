//
//  ImageController.swift
//  UserJSON1
//
//  Created by Aron Veress on 23/08/2022.
//

import UIKit

class ImageController {
    static let sharedInstance = ImageController()
    private init() {}
    
    private var images: Dictionary<String,UIImage> = Dictionary<String, UIImage>()
    
    
    func requestImage(url: URL, onSuccess: @escaping ((UIImage)->Void)) {
        if(self.images[url.absoluteString] != nil) {
            onSuccess(self.images[url.absoluteString]!)
        } else {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if(error == nil){
                    DispatchQueue.main.async() {
                        self.images[url.absoluteString] = UIImage(data: data!)
                        onSuccess(self.images[url.absoluteString]!)
                    }
                }
            }
            task.resume()
        }
    }
}

