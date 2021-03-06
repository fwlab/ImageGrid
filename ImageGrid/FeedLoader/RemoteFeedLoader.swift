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

    public typealias FeedResult = Result<[User],RemoteFeedError>
    
    public func load(completion: @escaping (FeedResult) -> Void) {
        client.get(from: url) { [weak self] result in
            switch result {
            case .success(let data, let response):
                guard response.statusCode == 200
                    else {
                        completion(.failure(.invalidResponse))
                        return
                }
                // ensure it is valid JSON
                if let results = self?.decode(data: data) {
                        completion(.success(results))
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
    
    private func decode(data:Data) -> [User]? {
        let decoder = JSONDecoder()
        if let results = try? decoder.decode(Results.self, from: data) {
            return results.results
        } else {
            // decoding error
            return nil
        }
    }
}
