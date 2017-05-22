//
//  ImageListViewModel.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 22/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

final class ImageListViewModel {
    // MARK: Properties
    private(set) var state = ImageListState(tweets: []) {
        didSet {
            callback(state)
        }
    }
    
    let callback: (ImageListState) -> ()
    
    // MARK: Designated Initializer
    init(callback: @escaping (ImageListState) -> ()) {
        self.callback = callback
        self.callback(self.state)
    }
    
    // MARK: Public Methods
    func hasBearerToken() -> Bool {
        return UserDefaults.standard.bearerToken() != nil ? true : false
    }
    
    func fetchTokenThenTweets(with webService: WebService = WebService(session: URLSession.appOnlyAuth)) {
        webService.load(resource: bearerToken()) { (result) in
            switch result {
            case .success:
                self.fetchTweets()
            case let .failure(error):
                // TODO: Show error
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTweets(with webService: WebService = WebService(session: URLSession.bearerToken)) {
        webService.load(resource: TwitterImage.tweets) { (result) in
            switch result {
            case let .success(tweets):
                self.state.tweets = tweets
            case let .failure(error):
                // TODO: Show error
                print(error.localizedDescription)
            }
        }
    }
}
