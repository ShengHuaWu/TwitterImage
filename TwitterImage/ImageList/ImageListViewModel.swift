//
//  ImageListViewModel.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 22/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Image List View Model
final class ImageListViewModel {
    // MARK: Properties
    private(set) var state: State<[ImageTweet]> = .normal([]) {
        didSet {
            callback(state)
        }
    }
    
    private let callback: (State<[ImageTweet]>) -> ()
    private let imageProvider: ImageProvider
    
    // MARK: Designated Initializer
    init(imageProvider: ImageProvider = ImageProvider(), callback: @escaping (State<[ImageTweet]>) -> ()) {
        self.imageProvider = imageProvider
        
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
    
    func startFetching() {
        state = .loading
    }
    
    func downloadImage(at indexPath: IndexPath, with completion: @escaping (URL) -> ()) {
        guard let tweet = state.tweet(at: indexPath) else { return }
        
        imageProvider.load(at: tweet.mediaURL, to: tweet.fileURL()) { (result) in
            switch result {
            case let .success(url):
                completion(url)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func suspendDownloadingImage() {
        imageProvider.suspendLoading()
    }
    
    func resumeDownloadingImage() {
        imageProvider.resumeLoading()
    }
}

// MARK: - Image Tweet Extension
extension ImageTweet {
    var mediaURL: URL {
        return URL(string: mediaURLString)!
    }
    
    func fileURL(with suffix: String = "", userDefaults: UserDefaults = UserDefaults.standard) -> URL {
        guard let directoryURL = userDefaults.temporaryDirectoryURL() else {
            fatalError("Tempoaray directory doesn'r exist.")
        }
        
        return directoryURL.appendingPathComponent(twitterID + suffix)
    }
}
