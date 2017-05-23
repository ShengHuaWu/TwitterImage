//
//  State.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 23/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

enum State<T> {
    case loading
    case normal(T)
    case error(Error)
}

extension State where T == [ImageTweet] {
    var count: Int {
        switch self {
        case let .normal(tweets): return tweets.count
        default: return 0
        }
    }
    
    func userName(at indexPath: IndexPath) -> String? {
        switch self {
        case let .normal(tweets): return tweets[indexPath.row].userName
        default: return nil
        }
    }
    
    func tweet(at indexPath: IndexPath) -> ImageTweet? {
        switch self {
        case let .normal(tweets): return tweets[indexPath.row]
        default: return nil
        }
    }
}

extension State where T == ImageTweet {
    var userName: String? {
        switch self {
        case let .normal(tweet): return tweet.userName
        default: return nil
        }
    }
    
    var text: String? {
        switch self {
        case let .normal(tweet): return tweet.text
        default: return nil
        }
    }
}
