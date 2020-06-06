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
        let clientError = RemoteFeedError(rawValue: "connection")!
        
        var capturedErrors = [RemoteFeedError]()
        sut.load { capturedErrors.append($0) }
        client.complete(with: clientError)
        XCTAssertEqual(capturedErrors,[RemoteFeedError.connection])
    }
    
    
 // MARK Helpers
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var capturedErrors = [RemoteFeedError]()
        var completions = [(RemoteFeedError)->Void]()
        var error: RemoteFeedError?
        func get(from url: URL, completion: @escaping (RemoteFeedError) -> Void) {
            completions.append(completion)
            requestedURLs.append(url)
        }
        func complete(with error: RemoteFeedError, at index: Int = 0) {
            completions[index](error)
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
