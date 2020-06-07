//
//  RemoteFeedClient.swift
//  ImageGrid
//
//  Created by Michele Fadda on 07/06/2020.
//

import Foundation

public class RemoteFeedClient: HTTPClient {
    let session: URLSession
    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            session.dataTask(with: url) { (data, response, err) in
                if err != nil {
                    completion(.failure(.connectionError))
                } else {
                    if let data=data, let response=response as? HTTPURLResponse {
                        switch (data, response.statusCode) {
                        case (data, 200):
                                completion(.success(data, response))
                        case (data, 0...199):
                            completion(.failure(.invalidResponse))
                        case (data, 201...):
                            completion(.failure(.invalidResponse))
                        default:
                            completion(.failure(.invalidData))
                        }
                    } else {
                        completion(.failure(.invalidData))
                    }
                }
            }.resume()
        }
    public init(){
        let cache = URLCache(memoryCapacity: 1000_000, diskCapacity: 10_000_000, diskPath: nil) // these numbers will need to be tuned!
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        let session = URLSession(configuration: configuration)
        self.session = session
    }
}
