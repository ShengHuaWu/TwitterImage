//
//  TwitterImage.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 21/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Serialization Error
enum SerializationError: Error {
    case missing(String)
}

// MARK: - Image Tweet
struct ImageTweet {
    let twitterID: String
    let text: String
    let mediaURLString: String
    let userName: String
    let userScreenName: String
    let userProfileImageURLString: String
    let createdAt: String
}

typealias JSONDictionary = [String : Any]

extension ImageTweet {
    init(json: JSONDictionary) throws {
        guard let twitterID = json["id_str"] as? String else {
            throw SerializationError.missing("id_str")
        }
        
        guard let text = json["text"] as? String else {
            throw SerializationError.missing("text")
        }
        
        guard let entities = json["entities"] as? JSONDictionary,
            let media = entities["media"] as? [JSONDictionary],
            let mediaJSON = media.first,
            let mediaURLString = mediaJSON["media_url_https"] as? String else {
            throw SerializationError.missing("media")
        }
        
        guard let userJSON = json["user"] as? JSONDictionary,
            let userName = userJSON["name"] as? String,
            let userScreenName = userJSON["screen_name"] as? String,
            let userProfileImageURLString = userJSON["profile_image_url_https"] as? String else {
            throw SerializationError.missing("user")
        }
        
        guard let createdAt = json["created_at"] as? String else {
            throw SerializationError.missing("created_at")
        }
        
        self.twitterID = twitterID
        self.text = text
        self.mediaURLString = mediaURLString
        self.userName = userName
        self.userScreenName = userScreenName
        self.userProfileImageURLString = userProfileImageURLString
        self.createdAt = createdAt
    }
}

fileprivate extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    func hasMedia() -> Bool {
        guard let entities = self["entities"] as? JSONDictionary,
            let _ = entities["media"] as? [JSONDictionary] else {
            return false
        }
        
        return true
    }
}

extension ImageTweet {
    static let tweets = Resource(url: URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=%23recipes%20filter%3Aimages&include_entities=true&count=100")!) { (json) throws -> [ImageTweet] in
        guard let dictionary = json as? JSONDictionary,
            let statuses = dictionary["statuses"] as? [JSONDictionary] else {
            throw SerializationError.missing("statuses")
        }
        
        // Not every tweet has media dictionary
        return try statuses.filter{ $0.hasMedia() }.map(ImageTweet.init)
    }
}
