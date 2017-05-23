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
    
    private let callback: (State<ImageTweet>) -> ()
    
    // MARK: Designated Initializer
    init(tweet: ImageTweet, callback: @escaping (State<ImageTweet>) -> ()) {
        self.state = .normal(tweet)
        
        self.callback = callback
        self.callback(self.state)
    }
    
    // MARK: Public Methods
    func downloadImage(with imageProvider: ImageProvider = ImageProvider(), completion: @escaping (URL) -> ()) {
        guard let tweet = state.tweet else { return }
        
        imageProvider.load(tweet.mediaURL, for: tweet.twitterID) { (result) in
            switch result {
            case let .success(url):
                completion(url)
            case let .failure(error):
                print(error)
            }
        }
    }
}
