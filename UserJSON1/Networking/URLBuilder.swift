//
//  URLBuilder.swift
//  UserJSON1
//
//  Created by Aron Veress on 24/08/2022.
//

import Foundation

class URLBuilder {
    
    func getUrlForRandomUsers(call: String, seed: String) -> URL?{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "randomuser.me"
        urlComponents.path = "/api/"
        urlComponents.queryItems = [
            URLQueryItem(name: "results", value: call),
            URLQueryItem(name: "seed", value: seed)
        ]
        return urlComponents.url
    }
}
