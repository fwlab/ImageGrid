//
//  RemoteFeedLoaderTests.swift
//  ImageGrid
//
//  Created by Michele Fadda on 05/06/2020.
//

import XCTest
import FeedLoader

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataUponCreation() {
        let (_,client) = makeSUT()
        XCTAssertEqual(client.requestedURLs.count,0)
    }

    func test_load_RequestsDataFromURL() {
        let url = anyURL()
        let (sut,client) = makeSUT(url: url)
        sut.load{ _ in }
        XCTAssertEqual(client.requestedURLs,[url])
    }
    
    func test_loadTwice_RequestsDataFromURLTwice() {
        let url = anyURL()
        let (sut,client) = makeSUT(url: url)
        sut.load{ _ in }
        sut.load{ _ in }
        XCTAssertEqual(client.requestedURLs,[url,url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut,client) = makeSUT()
        client.error = RemoteFeedError(rawValue: "connection")
        var capturedErrors = [RemoteFeedError]()
        sut.load{ capturedErrors.append ($0) }
        XCTAssertEqual(capturedErrors,[RemoteFeedError.connection])
    }
    
    
 // MARK Helpers
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: RemoteFeedError?
        func get(from url: URL, completion: (RemoteFeedError) -> Void) {
            if let error = error {
              completion(error)
            }
            requestedURLs.append(url)
        }
    }

    
    private func makeSUT(url: URL = URL(string: "https://any-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeedLoader(from: url, client: client), client)
    }
    
    func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
}
