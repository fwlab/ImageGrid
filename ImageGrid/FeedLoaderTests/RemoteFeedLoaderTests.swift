//
//  RemoteFeedLoaderTests.swift
//  ImageGrid
//
//  Created by Michele Fadda on 05/06/2020.
//

import XCTest
@testable import FeedLoader

enum LoadFeedResult {
    case success(Results)
    case error(Error)
}

protocol FeedLoader {
    func load(completion: (Results)->Void )
}

protocol HTTPClient {
    func get(from url: URL, completion: (Results)-> Void )
}



class RemoteFeedLoader: FeedLoader {
    func load(completion: (Results) -> Void) {
        client.get(from: url) { (results) in
            
        }
    }

    let client: HTTPClient
    let url: URL
    init(from url:URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}


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
    
    

    
 // MARK Helpers
    
    class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()

        func get(from url: URL, completion: (Results) -> Void) {
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
