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
    private(set) var state: ImageListState = .normal([]) {
        didSet {
            callback(state)
        }
    }
    
    let callback: (ImageListState) -> ()
    
    // MARK: Designated Initializer
    init(callback: @escaping (ImageListState) -> ()) {
        self.callback = callback
    }
    
    // MARK: Public Methods
    func hasBearerToken(in userDefaults: UserDefaults = UserDefaults.standard) -> Bool {
        return userDefaults.bearerToken() != nil ? true : false
    }
    
    func fetchTokenThenTweets(with webService: WebServiceProtocol = WebService(session: URLSession.appOnlyAuth)) {
        webService.load(resource: bearerToken()) { (result) in
            switch result {
            case .success:
                self.fetchTweets()
            case let .failure(error):
                self.state = .error(error)
            }
        }
    }
    
    func fetchTweets(with webService: WebServiceProtocol = WebService(session: URLSession.bearerToken)) {
        webService.load(resource: ImageTweet.tweets) { (result) in
            switch result {
            case let .success(tweets):
                self.state = .normal(tweets)
            case let .failure(error):
                self.state = .error(error)
            }
        }
    }
}
