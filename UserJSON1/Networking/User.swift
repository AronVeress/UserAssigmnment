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
    let gender: String
    let name: Name
    let email: String
    let picture: Picture
    let registered: Registered
    let location: Location
    let dob: Dob
    let phone: String
    let cell: String
    let login: Login
}

struct Name: Codable{
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable{
    let thumbnail: URL
    let large: URL
}

struct Registered: Codable {
    let date: Date
}

struct Location: Codable {
    let street: Street
    let city: String
    let country: String
}

struct Street: Codable {
    let number: Int
    let name: String
}

struct Dob: Codable{
    let date: Date
    let age: Int
}

struct Login: Codable {
    let uuid: String
}
