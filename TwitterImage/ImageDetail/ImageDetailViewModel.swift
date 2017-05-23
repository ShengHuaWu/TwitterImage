//
//  ImageDetailViewModel.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 23/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

final class ImageDetailViewModel {
    // MARK: Properties
    private(set) var state: State<ImageTweet> {
        didSet {
            callback(state)
        }
    }
    
    let callback: (State<ImageTweet>) -> ()
    
    // MARK: Designated Initializer
    init(tweet: ImageTweet, callback: @escaping (State<ImageTweet>) -> ()) {
        self.state = .normal(tweet)
        
        self.callback = callback
        self.callback(self.state)
    }
}
