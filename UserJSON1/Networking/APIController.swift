//
//  APIController.swift
//  UserJSON1
//
//  Created by Aron Veress on 23/08/2022.
//

import UIKit

typealias JsonObj = Dictionary<String, Any?>

class APIController {
    
    static let sharedInstance = APIController()
    init () {}
    private var seed = ""
    private var onRequest = false
    var call = "100"
    private var mySeed = "abc"
    
    func downloadJson(item: String, onSuccess: @escaping ((Array<User>)->Void), onFail: @escaping ((Error)->Void)) {
        self.onRequest = true
        
        let myURL = URLBuilder()
        
        let url = myURL.getUrl(call: call, seed: mySeed)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if(error != nil) {
                DispatchQueue.main.async {
                    self.onRequest = false
                    onFail(error!)
                }
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as! JsonObj
                    
                    DispatchQueue.main.async {
                        onSuccess((result["results"] as! Array<JsonObj>).map {
                            User(dict: $0)
                        })
                    }
                }
                catch let error {
                    DispatchQueue.main.async {
                        self.onRequest = false
                        onFail(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func isOnRequest() -> Bool {
        return onRequest
    }
}


