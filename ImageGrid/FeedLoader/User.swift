//
//  User.swift
//  ImageGridView
//
//  Created by Michele Fadda on 04/06/2020.
//

import Foundation

public struct Picture: Decodable {
    public var large:String?
    public var medium:String?
    public var thumbnail:String?
}

public struct User: Decodable {
    public var picture: Picture
}

public struct Results: Decodable {
    public var results: [User]
}
