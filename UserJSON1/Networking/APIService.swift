//
//  APIService.swift
//  UserJSON1
//
//  Created by Aron Veress on 23/08/2022.
//

import UIKit

typealias JsonObj = Dictionary<String, Any?>

class APIService {
    
    static var sharedInstance = APIService()
    private var seed = ""
    var usersCount = "100"
    private var mySeed = "abc"
    
    func fetchUsers(item: String, onSuccess: @escaping ((Array<User>)->Void), onFail: @escaping ((Error)->Void)) {

        let myURL = URLBuilder()
        
        guard let url = myURL.getUrlForRandomUsers(call: usersCount, seed: mySeed) else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onFail(error)
                return
            } else {
                do {
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    
                    let result = try decoder.decode(Users.self, from: data!)
                    onSuccess(result.results)
                    
                }
                    catch let error {
                        print(String(describing: error))
                }
            }
        }
        task.resume()
    }
}


