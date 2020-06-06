//
//  RemoteFeedLoader.swift
//  FeedLoader
//
//  Created by Michele Fadda on 06/06/2020.
//

import Foundation

public enum RemoteFeedError: String, Swift.Error {
    case connection = "connection"
}

public final class RemoteFeedLoader: FeedLoader {
    
    private let url: URL
    private let client: HTTPClient

    
    public func load(completion: @escaping (RemoteFeedError) -> Void) {
        client.get(from: url) { (error) in
            completion(.connection)
        }
        
    }
    
    
    public init(from url:URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}
