//
//  RemoteFeedLoaderTests.swift
//  ImageGrid
//
//  Created by Michele Fadda on 05/06/2020.
//

import XCTest

// ensure this tests run on Mac as well on iOS
#if os(OSX)
    import FeedLoader
#else
    import FeedLoaderiOS
#endif

class RemoteFeedLoaderTests: XCTestCase {
    
    // verify it does not request data without load()
    func test_init_doesNotRequestDataUponCreation() throws {
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
    func test_loadTwice_RequestsDataFromURLTwice() throws {
        let url = anyURL()
        let (sut,client) = makeSUT(url: url)
        sut.load{ _  in }
        sut.load{ _  in }
        XCTAssertEqual(client.requestedURLs,[url,url])
    }
    
    // verify it delivers the same error client reports
    func test_load_deliversErrorOnClientError() throws {
        let (sut,client) = makeSUT()
        let clientError = RemoteFeedError(rawValue: "connectionError")!
        
        var capturedErrors = [RemoteFeedError]()
        sut.load { result in
            switch result {
            case .success(_,_):
                XCTFail()
                break
            case .failure(let error):
                capturedErrors.append(error)
            }
        }
        client.complete(with: clientError)
        XCTAssertEqual(capturedErrors,[RemoteFeedError.connectionError])
    }
    
    // if client gets a non 200 response, verify it is a response error
    func test_load_deliversErrorIfHttpResponseNot200() throws {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        sut.load { result in
            switch result {
            case .success(_,_):
                XCTFail()
                break
            case .failure(let error):
                capturedErrors.append(error)
            }
        }
        
        client.complete(withStatusCode: 400)
        XCTAssertEqual(capturedErrors,[RemoteFeedError.invalidResponse])
    }

    // if client gets any non 200 response, verify it is a response error
    func test_load_deliversErrorForHttpResponsesNot200() throws {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        
        let simulatedResponsesCodes = [0,199,201,300,400,500,999]
        
        simulatedResponsesCodes.enumerated().forEach { index,responseCode in
            sut.load { result in
                switch result {
                case .success(_,_):
                    XCTFail()
                    break
                case .failure(let error):
                    capturedErrors.append(error)
                }
            }
            client.complete(withStatusCode: responseCode, data: makeValidJSON(), at: index)
            
            XCTAssertEqual(capturedErrors[index],RemoteFeedError.invalidResponse)
        }
    }
    
    // verify that a response 200 is not considered an error
    func test_load_doesNotDeliverErrorForHttpResponses200WithValidJSON() throws {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        
        let simulatedResponsesCodes = [200]
        
        simulatedResponsesCodes.enumerated().forEach { index,responseCode in
            sut.load { result in
                switch result {
                case .success(_,_):
                    break
                case .failure(let error):
                    capturedErrors.append(error)
                }
            }
            let data = Data("{\"results\": []}".utf8)
            client.complete(withStatusCode: responseCode,data:data, at: index)
            
            XCTAssertEqual(capturedErrors.count,0)
        }
    }

    // verify response for status code 200 is not nil with valid JSON
    func test_load_deliversNotNilResponseForHttpResponses200() throws {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        
        let simulatedResponsesCodes = [200]
        
        simulatedResponsesCodes.enumerated().forEach { index,responseCode in
            sut.load { result in
                switch result {
                case .success( _,let response):
                    XCTAssertNotNil(response)
                    break
                case .failure(let error):
                    capturedErrors.append(error)
                    XCTFail()
                }
            }
            let data = Data("{\"results\": []}".utf8)
            client.complete(withStatusCode: responseCode,data:data, at: index)
            
            XCTAssertEqual(capturedErrors.count,0)
        }
    }

    // verify status code 200 is considered success with valid JSON
    func test_load_deliversSuccessForHttpResponses200WithValidJSON() throws {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        
        let simulatedResponsesCodes = [200]
        
        simulatedResponsesCodes.enumerated().forEach { index,responseCode in
            sut.load { result in
                switch result {
                case .success( _,let response):
                    XCTAssertEqual(response.statusCode,200)
                    break
                case .failure(let error):
                    capturedErrors.append(error)
                    XCTFail()
                }
            }
            let data = Data("{\"results\": []}".utf8)
            client.complete(withStatusCode: responseCode,data:data, at: index)
            
            XCTAssertEqual(capturedErrors,[])
        }
    }
    
    // verify status code 200 is considered failure with invalid JSON
    func test_load_deliversErrorForHttpResponses200InvalidJSON() throws {
        let (sut,client) = makeSUT()
        var capturedErrors = [RemoteFeedError]()
        let responseCode = 200
        sut.load { result in
                switch result {
                case .success( _,let response):
                    XCTAssertEqual(response.statusCode,200)
                    XCTFail()
                    break
                case .failure(let error):
                    capturedErrors.append(error)
                }
        }
        client.complete(withStatusCode: responseCode, data: invalidJSON() )
            
        XCTAssertEqual(capturedErrors,[RemoteFeedError.invalidData])
        }
    

        // verify valid JSON
        func test_load_deliversValidJSON() throws {
            let (sut,client) = makeSUT()
            var capturedErrors = [RemoteFeedError]()
            let responseCode = 200
            sut.load { result in
                switch result {
                case .success(let users,let response):
                    XCTAssertEqual(response.statusCode,200)
                    if let urlString = users[0].picture.thumbnail
                    {
                        XCTAssertEqual(urlString, "https://randomuser.me/api/portraits/thumb/men/81.jpg")
                    } else {
                        XCTFail()
                    }
                    break
                case .failure(let error):
                    capturedErrors.append(error)
                }
            }
            client.complete(withStatusCode: responseCode, data: makeValidJSON() )
            
            
        
            XCTAssertEqual(capturedErrors,[])
        }
    
    // MARK Helpers

    func trackForMemoryLeaks (instance: AnyObject,
                              line:UInt=#line,
                              file:StaticString=#file) {
        addTeardownBlock {
            [weak instance] in
            XCTAssertNil(instance, "instance not deallocated after test run at line \(line) in\(file)")
        }
    }
    
    func makeSUT(url: URL = URL(string: "https://any-url.com")!,
                 line:UInt=#line,
                 file:StaticString=#file) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        
        let remotFeedLoader = RemoteFeedLoader(from: url, client: client)
        trackForMemoryLeaks(instance: remotFeedLoader,line: line,file: file)
        trackForMemoryLeaks(instance: client,line: line,file: file)
        return (remotFeedLoader,client)
    }

     class HTTPClientSpy: HTTPClient {
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
        func complete(withStatusCode: Int,
                      data: Data=invalidJSON(),
                      at index: Int = 0 ) {
            if let response = HTTPURLResponse(url: requestedURLs[index], statusCode: withStatusCode, httpVersion: nil, headerFields: nil) {
                invocations[index].completion(.success(data,response))
            }

        }
        

    }

}

    
    


    func makeValidJSON() -> Data {
       return Data("{\"results\":[{\"gender\":\"male\",\"name\":{\"title\":\"Mr\",\"first\":\"Konsta\",\"last\":\"Juntunen\"},\"location\":{\"street\":{\"number\":3426,\"name\":\"Hermiankatu\"},\"city\":\"Varkaus\",\"state\":\"Kainuu\",\"country\":\"Finland\",\"postcode\":98452,\"coordinates\":{\"latitude\":\"-8.2002\",\"longitude\":\"-32.4747\"},\"timezone\":{\"offset\":\"-3:30\",\"description\":\"Newfoundland\"}},\"email\":\"konsta.juntunen@example.com\",\"login\":{\"uuid\":\"73552e3f-bd0f-43c9-9ea8-5c8d5addb516\",\"username\":\"purpleleopard418\",\"password\":\"times\",\"salt\":\"TZa0mXKd\",\"md5\":\"541fc87c70b99c38ea9ef2ad066d25c0\",\"sha1\":\"83e919b1a08a350f6e87896311426d6c88541319\",\"sha256\":\"3f8100ac1d6047a4d968dace3203b5c51edbef94c8e347aaa789d87728e43b7b\"},\"dob\":{\"date\":\"1988-04-28T16:06:34.709Z\",\"age\":32},\"registered\":{\"date\":\"2011-08-28T09:49:19.053Z\",\"age\":9},\"phone\":\"04-688-730\",\"cell\":\"044-628-78-48\",\"id\":{\"name\":\"HETU\",\"value\":\"NaNNA201undefined\"},\"picture\":{\"large\":\"https://randomuser.me/api/portraits/men/81.jpg\",\"medium\":\"https://randomuser.me/api/portraits/med/men/81.jpg\",\"thumbnail\":\"https://randomuser.me/api/portraits/thumb/men/81.jpg\"},\"nat\":\"FI\"}],\"info\":{\"seed\":\"548a8dcaf10f3e20\",\"results\":1,\"page\":1,\"version\":\"1.3\"}}".utf8)
    }
    
    func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }

    func invalidJSON() -> Data {
        return Data("this is invalid data".utf8)
    }

