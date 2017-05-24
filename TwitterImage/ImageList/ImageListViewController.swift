//
//  ImgaesViewController.swift
//  TwitterImage
//
//  Created by ShengHua Wu on 22/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

// MARK: - Image List View Controller
final class ImageListViewController: UIViewController {
    // MARK: Properties
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.description())
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "Fetching Tweets ...")
        control.addTarget(self, action: #selector(fetchTweetsAction(sender:)), for: .valueChanged)
        collectionView.refreshControl = control
        
        return collectionView
    }()
    
    var viewModel: ImageListViewModel!
    var didSelect: ((ImageTweet) -> ())?
    var presentError: ((Error) -> ())?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image Tweets"
        
        view.addSubview(collectionView)
        
        fetchTweets()
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
    
    // MARK: Actions
    func fetchTweetsAction(sender: UIRefreshControl) {
        fetchTweets()
    }
    
    // MARK: Private Methods
    private func fetchTweets() {
        viewModel.startFetching()
        
        if viewModel.hasBearerToken() {
            viewModel.fetchTweets()
        } else {
            viewModel.fetchTokenThenTweets()
        }
    }
    
    // MARK: Public Methods
    func updateUI(with state: State<[ImageTweet]>) {
        switch state {
        case .loading:
            collectionView.refreshControl?.beginRefreshing()
        case let .error(error):
            collectionView.refreshControl?.endRefreshing()
            presentError?(error)
        case .normal:
            collectionView.refreshControl?.endRefreshing()
            collectionView.reloadData()
        }
    }
}

// MARK: - Collection View Data Source
extension ImageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.description(), for: indexPath) as? ImageCell else {
            fatalError("Cell isn't ImageCell")
        }

        cell.nameLabel.text = viewModel.state.tweet(at: indexPath)?.userName
        viewModel.downloadImage(at: indexPath) { (url) in
            guard cell.imageView.image == nil else { return }
            
            let data = try! Data(contentsOf: url)
            cell.imageView.image = UIImage(data: data)
        }
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension ImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.state.tweet(at: indexPath).flatMap{ didSelect?($0) }
    }
}

// MARK: - Scroll View Delegate
extension ImageListViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.suspendDownloadingImage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate, case .normal = viewModel.state else { return }
        
        viewModel.resumeDownloadingImage()
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard case .normal = viewModel.state else { return }
        
        viewModel.resumeDownloadingImage()
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
}
