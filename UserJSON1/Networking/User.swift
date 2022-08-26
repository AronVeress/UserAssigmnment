//
//  User.swift
//  UserJSON1
//
//  Created by Aron Veress on 14/08/2022.
//

import Foundation

typealias dictionaryStr = Dictionary<String, String>

struct Users{
    let results: [User]
}

struct User {
    let name: Name
    let email: String
    let picture: Picture
    let registered: Registered
    
    init(dict: JsonObj) {
        name = Name(dict: dict["name"] as! dictionaryStr)
        email = dict["email"] as? String ?? ""
        registered = Registered(dict: dict["registered"] as! JsonObj)
        picture = Picture(dict: dict["picture"] as! dictionaryStr)
    }
}

struct Name{
    let first: String
    let last: String
    
    init(dict: dictionaryStr) {
        first = dict["first"] ?? ""
        last = dict["last"] ?? ""
    }
}

struct Registered {
    let date: Date
    
    init(dict: JsonObj){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        date = formatter.date(from: dict["date"] as? String ?? "") ?? Date()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
    }
}

struct Picture{
    let thumbnail: URL
    
    init(dict: dictionaryStr) {
        thumbnail = URL(string: dict["thumbnail"] ?? "")!
    }
}
