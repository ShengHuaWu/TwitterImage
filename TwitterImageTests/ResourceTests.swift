//
//  ResourceTests.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 21/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import XCTest
@testable import TwitterImage

class ResourceTests: XCTestCase {
    // MARK: Enabled Tests
    func testParsingBearerToken() {
        let userDefaults = UserDefaults(suiteName: #file)!
        userDefaults.removePersistentDomain(forName: #file)
        
        let token = "123456789"
        let data = try! JSONSerialization.data(withJSONObject: ["access_token" : token], options: [])

        do {
            let result = try bearerToken(with: userDefaults).parser(data)
            XCTAssert(result)
            XCTAssertEqual(token, userDefaults.bearerToken())
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testParsingTweets() {
        let tweet: JSONDictionary = [
            "id_str" : "1",
            "text" : "How are you?",
            "entities" : [
                "media" : [
                    ["media_url_https" : "https://developer.apple.com"]
                ]
            ],
            "user" : [
                "name" : "Shane Wu",
                "screen_name" : "shanewu",
                "profile_image_url_https" : "https://developer.apple.com"
            ],
            "created_at" : "Sun May 21 07:23:44 +0000 2017"
            ]
        let data = try! JSONSerialization.data(withJSONObject: ["statuses" : [tweet]], options: [])
        
        do {
            let tweets = try TwitterImage.tweets.parser(data)
            XCTAssertEqual(tweets.count, 1)
            XCTAssertNotNil(tweets.first)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
