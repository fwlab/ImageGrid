//
//  RemoteFeedError.swift
//  FeedLoader
//
//  Created by Michele Fadda on 06/06/2020.
//

import Foundation

public enum RemoteFeedError: String, Swift.Error {
    case connectionError = "connectionError"
    case invalidResponse = "invalidResponse"
    case invalidData = "invalidData"
}
