//
//  RemoteFeedLoader.swift
//  FeedLoader
//
//  Created by Michele Fadda on 06/06/2020.
//

import Foundation

class RemoteFeedLoader: FeedLoader {
    let client: HTTPClient
    let url: URL

    func load(completion: @escaping (Results) -> Void) {
        client.get(from: url) { (results) in }
    }

    init(from url:URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}
