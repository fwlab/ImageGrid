//
//  RemoteFeedLoader.swift
//  FeedLoader
//
//  Created by Michele Fadda on 06/06/2020.
//

import Foundation



public final class RemoteFeedLoader: FeedLoader {
    
    private let url: URL
    private let client: HTTPClient

    
    public func load(completion: @escaping (HTTPClientResult) -> Void) {
        client.get(from: url) { (result) in
            switch result {
                
            case .success(let response as HTTPURLResponse?):
                if response?.statusCode == 200 {
                    completion(result)
                } else {
                    completion(.failure(.invalidResponse))
                }
            case .failure(_):
                completion(result)
            }
                
        }
        
    }
    
    
    public init(from url:URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}
