//
//  User.swift
//  UserJSON1
//
//  Created by Aron Veress on 14/08/2022.
//

import UIKit

//decodable -> only getting information
struct Users: Decodable {
    let results: [User]
}

struct User: Decodable {
    let name: Name
    let email: String
    let picture: Picture
}

struct Name: Decodable{
    let first: String
    let last: String
}

struct Picture: Decodable {
    let thumbnail: String
    let large: String
}
