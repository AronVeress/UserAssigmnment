//
//  User.swift
//  UserJSON1
//
//  Created by Aron Veress on 14/08/2022.
//

import Foundation


struct Users: Codable{
    let results: [User]
}

struct User: Codable {
    let name: Name
    let email: String
    let picture: Picture
    let registered: Registered
    
}

struct Name: Codable{
    let first: String
    let last: String
    
}

struct Registered: Codable {
    let date: Date
    
}

struct Picture: Codable{
    let thumbnail: URL
    
}
