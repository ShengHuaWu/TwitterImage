//
//  ImageDetailViewModelTests.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 23/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import XCTest
@testable import TwitterImage

// MARK: - Image Detail View Model Tests
class ImageDetailViewModelTests: XCTestCase {
    // MARK: Properties
    private var viewModel: ImageDetailViewModel!
    
    // MARK: Override Methods
    override func setUp() {
        super.setUp()
        
        viewModel = ImageDetailViewModel(tweet: ImageTweet.fake) { _ in }
    }
    
    override func tearDown() {
        viewModel = nil
        
        super.tearDown()
    }
    
    // MARK: Enabled Tests
    func testDownloadImage() {
        let imageProvider = MockImageProvider()
        
        viewModel.downloadImage(with: imageProvider) { _ in }
        
        imageProvider.verify()
    }
}

// MARK: - Image Tweet Extension
extension ImageTweet {
    static let fake = ImageTweet(twitterID: "123", text: "This is a fake tweet", mediaURLString: "", userName: "", userScreenName: "", userProfileImageURLString: "", createdAt: "")
}

// MARK: - Mock Image Provider
final class MockImageProvider: ImageProviderProtocol {
    private var loadCallCount = 0
    
    func load(_ url: URL, for identifier: String, with completion: @escaping (Result<URL>) -> ()) {
        loadCallCount += 1
    }
    
    func suspendLoading() {
        
    }
    
    func resumeLoading() {
        
    }
    
    func verify(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(loadCallCount, 1, "call count", file: file, line: line)
    }
}
