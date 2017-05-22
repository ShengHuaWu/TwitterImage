//
//  ImageListState.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 22/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

enum ImageListState {
    case loading
    case normal([TwitterImage])
    case error(Error)
}

extension ImageListState {
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
}
