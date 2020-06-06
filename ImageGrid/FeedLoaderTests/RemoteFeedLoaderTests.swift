//
//  RemoteFeedLoaderTests.swift
//  ImageGrid
//
//  Created by Michele Fadda on 05/06/2020.
//

import XCTest
#if os(OSX)
    import FeedLoader
#else
    import FeedLoaderiOS
#endif

class RemoteFeedLoaderTests: XCTestCase {
    
    
    // verify it does not request data without load()
    func test_init_doesNotRequestDataUponCreation() {
        let (_,client) = makeSUT()
        XCTAssertEqual(client.requestedURLs.count,0)
    }

    // verify requested url matches client url
    func test_load_RequestsDataFromURL() {
        let url = anyURL()
        let (sut,client) = makeSUT(url: url)
        sut.load{ _  in }
        XCTAssertEqual(client.requestedURLs,[url])
    }
    
    // if loads is invoked twice, verify it requests data twice
    func test_loadTwice_RequestsDataFromURLTwice() {
        let url = anyURL()
        let (sut,client) = makeSUT(url: url)
        sut.load{ _  in }
        sut.load{ _  in }
        XCTAssertEqual(client.requestedURLs,[url,url])
    }
    
    // verify it delivers the same error client reports
    func test_load_deliversErrorOnClientError() {
        let (sut,client) = makeSUT()
        let clientError = RemoteFeedError(rawValue: "connectionError")!
        
        var capturedErrors = [RemoteFeedError]()
        sut.load { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                capturedErrors.append(error)
            }
        }
        client.complete(with: clientError)
        XCTAssertEqual(capturedErrors,[RemoteFeedError.connectionError])
    }
    
    // if client gets a non 200 response, verify it is a response error
    func test_load_deliversErrorIfHttpResponseNot200() {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        sut.load { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                capturedErrors.append(error)
            }
        }
        
        client.complete(withStatusCode: 400)
        XCTAssertEqual(capturedErrors,[RemoteFeedError.invalidResponse])
    }

    // if client gets any non 200 response, verify it is a response error
    func test_load_deliversErrorForHttpResponsesNot200() {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        
        let simulatedResponsesCodes = [0,199,201,300,400,500,999]
        
        simulatedResponsesCodes.enumerated().forEach { index,responseCode in
            sut.load { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    capturedErrors.append(error)
                }
            }
            client.complete(withStatusCode: responseCode, at: index)
            
            XCTAssertEqual(capturedErrors[index],RemoteFeedError.invalidResponse)
        }
    }
    
    // verify that a response 200 is not considered an error
    func test_load_doesNotDeliverErrorForHttpResponses200() {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        
        let simulatedResponsesCodes = [200]
        
        simulatedResponsesCodes.enumerated().forEach { index,responseCode in
            sut.load { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    capturedErrors.append(error)
                }
            }
            client.complete(withStatusCode: responseCode, at: index)
            
            XCTAssertEqual(capturedErrors.count,0)
        }
    }

    // verify response for status code 200 is not nil
    func test_load_deliversNotNilResponseForHttpResponses200() {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        
        let simulatedResponsesCodes = [200]
        
        simulatedResponsesCodes.enumerated().forEach { index,responseCode in
            sut.load { result in
                switch result {
                case .success(let response as HTTPURLResponse?):
                    XCTAssertNotNil(response)
                    break
                case .failure(let error):
                    capturedErrors.append(error)
                    XCTFail()
                }
            }
            client.complete(withStatusCode: responseCode, at: index)
            
            XCTAssertEqual(capturedErrors.count,0)
        }
    }

    // verify status code 200 is considered success
    func test_load_deliversSuccessForHttpResponses200() {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        
        let simulatedResponsesCodes = [200]
        
        simulatedResponsesCodes.enumerated().forEach { index,responseCode in
            sut.load { result in
                switch result {
                case .success(let response as HTTPURLResponse?):
                    XCTAssertEqual(response?.statusCode,200)
                    break
                case .failure(let error):
                    capturedErrors.append(error)
                    XCTFail()
                }
            }
            client.complete(withStatusCode: responseCode, at: index)
            
            XCTAssertEqual(capturedErrors.count,0)
        }
    }

    
 // MARK Helpers
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] {
            return invocations.map{ $0.url }
        }
        var completions = [(HTTPClientResult)->Void]()
        var invocations = [(url: URL,
                            completion: (HTTPClientResult)->Void)
                          ]()
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            invocations.append ((url:url,completion:completion))
        }
        func complete(with error: RemoteFeedError, at index: Int = 0) {
            invocations[index].completion(.failure(error))
        }
        func complete(withStatusCode: Int, at index: Int = 0) {
            if let response = HTTPURLResponse(url: requestedURLs[index], statusCode: withStatusCode, httpVersion: nil, headerFields: nil) {
                invocations[index].completion(.success(response))
            }

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
