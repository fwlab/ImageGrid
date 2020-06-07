//
//  Loader.swift
//  FeedLoader
//
//  Created by Michele Fadda on 05/06/2020.
//

import Foundation

public typealias RemoteFeedResult = Result<([User],HTTPURLResponse),RemoteFeedError>

public protocol FeedLoader {
    func load(completion: @escaping (RemoteFeedResult)->Void )
}
