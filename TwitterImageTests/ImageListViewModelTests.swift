//
//  ImageListViewModelTests.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 22/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import XCTest
@testable import TwitterImage

// MARK: - Image List View Model Tests
class ImageListViewModelTests: XCTestCase {
    // MARK: Properties
    private var viewModel: ImageListViewModel!
    
    // MARK: Override Methods
    override func setUp() {
        super.setUp()
        
        viewModel = ImageListViewModel { _ in }
    }
    
    override func tearDown() {
        viewModel = nil
        
        super.tearDown()
    }
    
    // MARK: Enabled Tests
    func testHasBearerToken() {
        let userDefaults = UserDefaults(suiteName: #file)!
        userDefaults.removePersistentDomain(forName: #file)
        
        userDefaults.setBearerToken("123456789")
        
        XCTAssert(viewModel.hasBearerToken(in: userDefaults))
    }
    
    func testFetchTweets() {
        let webService = MockWebService<[TwitterImage]>()
        
        viewModel.fetchTweets(with: webService)
        
        webService.verify(url: URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=%23cook%20filter%3Aimages&include_entities=true")!)
    }
    
    func testFetchTokenThenTweets() {
        let webService = MockWebService<Bool>()

        viewModel.fetchTokenThenTweets(with: webService)
        
        webService.verify(url: URL(string: "https://api.twitter.com/oauth2/token")!)
    }
}

// MARK: - Mock Web Service
final class MockWebService<U>: WebServiceProtocol {
    private(set) var loadCallCount = 0
    private(set) var expectedResource: Resource<U>!
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T>) -> ()) {
        loadCallCount += 1
        expectedResource = resource as Any as! Resource<U>
    }
    
    func verify(url: URL, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(loadCallCount, 1, "call count", file: file, line: line)
        XCTAssertEqual(expectedResource.url, url, "url", file: file, line: line)
    }
}
