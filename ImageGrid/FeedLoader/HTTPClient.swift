//
//  HTTPProtocol.swift
//  FeedLoader
//
//  Created by Michele Fadda on 06/06/2020.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion:@escaping (HTTPClientResult)-> Void )
}


public class RemoteFeedClient: HTTPClient {
    let session: URLSession = URLSession.shared
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
}
