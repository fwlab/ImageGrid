//
//  HTTPClientResult.swift
//  FeedLoader
//
//  Created by Michele Fadda on 06/06/2020.
//

import Foundation

public enum HTTPClientResult {
    case success(HTTPURLResponse)
    case failure(RemoteFeedError)
}
