//
//  Loader.swift
//  FeedLoader
//
//  Created by Michele Fadda on 05/06/2020.
//

import Foundation



public protocol FeedLoader {
    func load(completion: @escaping (RemoteFeedError)->Void )
}
