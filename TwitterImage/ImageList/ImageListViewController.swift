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
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.description())
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var loadingView = LoadingView(frame: .zero)
    
    fileprivate var viewModel: ImageListViewModel!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image Tweets"
        
        viewModel = ImageListViewModel { [weak self] (state) in
            guard let strongSelf = self else { return }
            
            strongSelf.updateUI(with: state)
        }
        
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        
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
        
        loadingView.frame = view.bounds
    }
    
    // MARK: - Private Methods
    private func fetchTweets() {
        viewModel.startFetching()
        
        if viewModel.hasBearerToken() {
            viewModel.fetchTweets()
        } else {
            viewModel.fetchTokenThenTweets()
        }
    }
    
    private func updateUI(with state: ImageListState) {
        switch state {
        case .loading:
            loadingView.isHidden = false
            collectionView.isHidden = true
            
            loadingView.startAnimating()
        case let .error(error):
            print(error.localizedDescription)
        case .normal:
            loadingView.isHidden = true
            collectionView.isHidden = false
            
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

        cell.nameLabel.text = viewModel.state.userName(at: indexPath)
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension ImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageDetailVC = ImageDetailViewController()
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
}
