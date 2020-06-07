//
//  FeedLoaderTests.swift
//  FeedLoaderTests
//
//  Created by Michele Fadda on 05/06/2020.
//

import XCTest
@testable import FeedLoader



class RemoteFeedLoaderTests: XCTestCase {


    func testLoaderHasURL() throws {
        let feedLoader: RemoteFeedLoader = makeSUT()
        XCTAssertNotNil(feedLoader.url)
    }
    
    func testLoaderInstantiation() throws {
        let feedLoader: RemoteFeedLoader = makeSUT()
        XCTAssertNotNil(feedLoader)
    }

    
    
 // MARK Helpers
    
    func anyUrl() -> URL {
        return URL(string:"https://any-url.com/")!
    }
    
    private func makeSUT() -> RemoteFeedLoader {
       return RemoteFeedLoader(url: anyUrl(), client: HTTPClientSpy() )
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }

}
