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

extension State where T: Collection, T.Index == Int, T.IndexDistance == Int {
    var count: Int {
        switch self {
        case let .normal(collection): return collection.count
        default: return 0
        }
    }
    
    func value(at indexPath: IndexPath) -> T.Iterator.Element? {
        switch self {
        case let .normal(collection): return collection[indexPath.row]
        default: return nil
        }
    }
}
