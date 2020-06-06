//
//  RemoteFeedLoader.swift
//  FeedLoader
//
//  Created by Michele Fadda on 06/06/2020.
//

import Foundation

public enum RemoteFeedError: String, Swift.Error {
    case connection = "connection"
    case invalid = "invalid"
}

public final class RemoteFeedLoader: FeedLoader {
    
    private let url: URL
    private let client: HTTPClient

    
    public func load(completion: @escaping (RemoteFeedError?,HTTPURLResponse?) -> Void) {
        client.get(from: url) { (error,response) in
            if response != nil {
                completion(.invalid, response)
            } else {
                completion(.connection,nil)
            }
        }
        
    }
    
    
    public init(from url:URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}
