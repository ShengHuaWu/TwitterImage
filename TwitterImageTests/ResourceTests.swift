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
    // MARK: Properties
    private var userDefaults: UserDefaults!
    
    // MARK: Overrider Methods
    override func setUp() {
        super.setUp()
        
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
    }
    
    override func tearDown() {
        userDefaults = nil
        
        super.tearDown()
    }
    
    // MARK: Enabled Tests
    func testBearToken() {
        let token = "123456789"
        let data = try! JSONSerialization.data(withJSONObject: ["access_token" : token], options: [])
        let resource = bearerToken(with: userDefaults)

        do {
            let result = try resource.parser(data)
            XCTAssert(result)
            XCTAssertEqual(token, userDefaults.bearerToken())
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
