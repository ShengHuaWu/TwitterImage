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
        // TODO: 
    }
}

// MARK: - Image Tweet Extension
extension ImageTweet {
    static let fake = ImageTweet(twitterID: "123", text: "This is a fake tweet", mediaURLString: "", userName: "", userScreenName: "", userProfileImageURLString: "", createdAt: "")
}
