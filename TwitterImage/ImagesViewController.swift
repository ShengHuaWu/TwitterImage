//
//  ImgaesViewController.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 22/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

// MARK: - Images View Controller
final class ImagesViewController: UIViewController {
    // MARK: Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.description())
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    fileprivate var tweets = [TwitterImage]()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Twitter Images"
        
        view.addSubview(collectionView)
        
        if let _ = UserDefaults.standard.bearerToken() {
            fetchTweets()
        } else {
            fetchTokenThenTweets()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let margin: CGFloat = 10.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        layout.itemSize = CGSize(width: (view.bounds.width - margin * 3.0) / 2.0, height: 200.0)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        
        collectionView.frame = view.bounds
    }
    
    // MARK: Private Methods
    private func fetchTokenThenTweets() {
        WebService(session: URLSession.appOnlyAuth).load(resource: bearerToken()) { (result) in
            switch result {
            case .success:
                self.fetchTweets()
            case let .failure(error):
                // TODO: Show error
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchTweets() {
        WebService(session: URLSession.bearerToken).load(resource: TwitterImage.tweets) { (result) in
            switch result {
            case let .success(tweets):
                self.tweets = tweets
                self.collectionView.reloadData()
            case let .failure(error):
                // TODO: Show error
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Collection View Data Source
extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.description(), for: indexPath) as? ImageCell else {
            fatalError("Cell isn't ImageCell")
        }

        let tweet = tweets[indexPath.row]
        cell.nameLabel.text = tweet.userName
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension ImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Show large image
    }
}
