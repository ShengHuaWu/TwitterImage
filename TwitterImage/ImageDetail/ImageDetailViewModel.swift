//
//  ImageDetailViewModel.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 23/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Image Detail View Model
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
        
        state = .loading
        imageProvider.load(at: tweet.largeMediaURL, to: tweet.fileURL(with: "large")) { (result) in
            switch result {
            case let .success(url):
                self.state = .normal(tweet)
                completion(url)
            case let .failure(error):
                self.state = .error(error)
            }
        }
    }
}

// MARK: - Image Tweet Extension
extension ImageTweet {
    var largeMediaURL: URL {
        return URL(string: mediaURLString + ":large")!
    }
}
