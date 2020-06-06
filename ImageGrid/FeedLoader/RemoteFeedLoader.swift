//
//  RemoteFeedLoader.swift
//  FeedLoader
//
//  Created by Michele Fadda on 06/06/2020.
//

import Foundation

class RemoteFeedLoader: FeedLoader {
    func load(completion: @escaping (Results) -> Void) {
        client.get(from: url) { (results) in }
    }

    let client: HTTPClient
    let url: URL
    init(from url:URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}
