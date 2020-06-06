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
        client.get(from: url) { result in
            switch result {
                
            case .success(let data, let response):
                guard response.statusCode == 200
                    else {
                        completion(.failure(.invalidResponse))
                        return
                }
                if let _ = try? JSONSerialization.jsonObject(with: data) {
                    completion(.success(data, response))
                } else {
                  completion(.failure(.invalidData))
                }
             case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public init(from url:URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}
