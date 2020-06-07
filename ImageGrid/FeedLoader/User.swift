//
//  User.swift
//  ImageGridView
//
//  Created by Michele Fadda on 04/06/2020.
//

import Foundation

public struct Picture: Codable {
//    public var large:String?
//    public var medium:String?
    public var thumbnail:String?
    public init(thumbnail:String) {
        self.thumbnail = thumbnail
    }
}

public struct User: Codable, Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.picture.thumbnail == rhs.picture.thumbnail
    }
    
    public var picture: Picture
    public init (picture: Picture) {
        self.picture = picture
    }
}

public struct Results: Codable {
    public var results: [User]
    public init(results: [User]) {
        self.results = results
    }
}
