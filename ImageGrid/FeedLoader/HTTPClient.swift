//
//  HTTPProtocol.swift
//  FeedLoader
//
//  Created by Michele Fadda on 06/06/2020.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion:@escaping (Results)-> Void )
}
