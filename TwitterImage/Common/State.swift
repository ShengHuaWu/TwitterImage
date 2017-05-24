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
    
    func tweet(at indexPath: IndexPath) -> ImageTweet? {
        switch self {
        case let .normal(tweets): return tweets[indexPath.item]
        default: return nil
        }
    }
}

extension State where T == ImageTweet {
    var tweet: ImageTweet? {
        switch self {
        case let .normal(tweet): return tweet
        default: return nil
        }
    }
}
