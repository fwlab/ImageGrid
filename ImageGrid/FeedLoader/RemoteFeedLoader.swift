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

    public func load(completion: @escaping (Results) -> Void) {
        client.get(from: url) { (results) in }
    }

    public init(from url:URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}
