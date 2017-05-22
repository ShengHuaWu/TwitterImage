//
//  ImageListState.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 22/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

struct ImageListState {
    var tweets: [TwitterImage]
    
    func userName(at indexPath: IndexPath) -> String {
        return tweets[indexPath.row].userName
    }
}
